class GroupsController < ApplicationController
  include ApplicationHelper

  before_action :check_authenticated, :only => [:created, :joined, :join, :leave, :create, :update, :personal_suggestions, :friends_suggestion]

  def created
    @groups = Group.all.where(owner: @user.id)

    respond_to do |format|
      format.json do
        render json: @groups.map { |group|
          {
              :id => "/groups/#{group.id}",
              :link => [
                  link('GET', 'group_info', "/groups/#{group.id}.json"),
                  link('DELETE', 'delete_info', "/groups/#{group.id}.json")
              ]
          }
        }
      end
    end
  end

  def joined
    @groups = Member
    .where(:user_id => @user.id)
    .map { |member| member.group }

    respond_to do |format|
      format.json do
        render json: @groups.map { |group|
          {
              :id => "/groups/#{group.id}",
              :link => [
                  link('group_info', 'GET', "/groups/#{group.id}.json"),
                  link('delete_info', 'DELETE', "/groups/#{group.id}.json")
              ]
          }
        }
      end
    end
  end

  def show
    @group = Group.find(params[:id])
    @rules = @group.rules

    respond_to do |format|
      format.json do
        render json: {
            :id => "/groups/#{@group.id}",
            :title => @group.title,
            :logo => @group.logo,
            :description => @group.description,
            :rules => @rules.map { |rule|
              {
                  :item_id => rule.item_id,
                  :filter_reason_id => "/filter_reasons/#{rule.filter_reason.id}"
              }
            },
            :links => [
                link('join_group', 'GET', "/groups/#{@group.id}/join.json"),
                link('leave_group', 'GET', "/groups/#{@group.id}/leave.json")
            ]
        }
      end
    end
  end

  def search
    @groups = Group
    .where('lower(title) like lower(?)', "%#{params[:name]}%")
    .limit(10)

    respond_to do |format|
      format.json do
        render json: @groups.map { |group|
          {
              :id => "/groups/#{group.id}",
              :link => [
                  link('group_info', 'GET', "/groups/#{group.id}.json"),
                  link('delete_info', 'DELETE', "/groups/#{group.id}.json")
              ]
          }
        }
      end
    end
  end

  def join
    @group = Group.find(params[:id])
    @member = Member.create(group_id: @group.id, user_id: @user.id)

    respond_to do |format|
      format.json do
        render json: {
            :id => "/groups/#{@group.id}",
            :links => [
                link('group_info', 'GET', "/groups/#{@group.id}.json"),
                link('leave_group', 'GET', "/groups/#{@group.id}/leave.json")
            ]
        }
      end
    end
  end

  def leave
    @group = Group.find(params[:id])
    @member = Member.where(group_id: @group.id, user_id: @user.id).first.delete

    respond_to do |format|
      format.json do
        render json: {
            :id => "/groups/#{@group.id}",
            :links => [
                link('group_info', 'GET', "/groups/#{@group.id}.json"),
                link('join_group', 'GET', "/groups/#{@group.id}/join.json")
            ]
        }
      end
    end
  end

  def create
    @group = Group.new

    json = JSON.parse(request.body.string)

    @group.owner = @user.id
    @group.title = json ['title']
    @group.logo = json ['logo']
    @group.description = json ['description']
    @group.rules = json ['rules'].map { |rule|
      Rule.create(item_id: rule['item_id'], filter_reason_id: rule['filter_reason_id'].match(/\/filter_reasons\/([0-9]+)/).captures[0])
    }

    @group.save

    respond_to do |format|
      format.json do
        render json: {
            :id => "/groups/#{@group.id}",
            :links => [
                link('group_info', 'GET', "/groups/#{@group.id}.json"),
                link('delete_group', 'DELETE', "/groups/#{@group.id}.json")
            ]
        }
      end
    end
  end

  def destroy

    respond_to do |format|
      format.json do
        begin
          @group = Group.find(params[:id])
          @group.destroy!

          render json: {}
        rescue
          render json: {message: 'Group not found'}
        end
      end
    end

  end

  def update
    @group = Group.find(params[:id])

    @group.owner = @user.id
    @group.title = params[:title]
    @group.logo = params[:logo]
    @group.description = params[:description]
    @group.rules = params[:rules].map { |rule|
      Rule.create(item_id: rule[:item_id], filter_reason_id: rule[:filter_reason_id].match(/\/filter_reasons\/([0-9]+)/).captures[0])
    }

    @group.save

    respond_to do |format|
      format.json do
        render json: {
            :id => "/groups/#{@group.id}",
            :links => [
                link('group_info', 'GET', "/groups/#{@group.id}.json"),
                link('delete_group', 'DELETE', "/groups/#{@group.id}.json")
            ]
        }
      end
    end
  end

  def trending
    @group_ids = Member.
        where('created_at > ?', 1.year.ago).
        group('group_id').
        count('id')

    @group_ids = @group_ids.to_a.
        sort_by { |_, value| value }.
        reverse![0..5].
        map { |pair| pair[0] }

    respond_to do |format|
      format.json do
        render json: @group_ids.map { |id|
          {
              :id => "/groups/#{id}",
              :links => [
                  link('group_info', 'GET', "/groups/#{id}.json"),
                  link('join_info', 'GET', "/groups/#{id}/join.json")
              ]
          }
        }
      end
    end
  end

  def personal_suggestions
    # Get all groups which were created by the user or which were joined by the user
    @group_ids = (Group.all.where(owner: @user.id) + Member.where(:user_id => @user.id).map { |member| member.group }).
        map { |group| group.id }.
        uniq { |id| id }

    # Get all item ids for the above groups
    @item_ids = Rule.where('group_id in (?)', @group_ids).
        map { |rule| rule.item_id }.
        uniq { |id| id }

    # Get groups which also have these item ids excluding the ones above
    @suggested = Rule.where('item_id in (?) and group_id not in (?)', @item_ids, @group_ids).
        group(:group_id).
        count(:id).
        to_a.
        sort_by {|_, v| v}.
        map { |k, _| k}.
        reverse![0..5]

    respond_to do |format|
      format.json do
        render json: @suggested.map{|id|
          {
              :id => "/groups/#{id}",
              :links => [
                  link('group_info', 'GET', "/groups/#{id}.json"),
                  link('join_info', 'GET', "/groups/#{id}/join.json")
              ]
          }
        }
      end
    end
  end

  def friends_suggestion
    # As the Google+ API is broken, I've chosen three random user ids as 'friends'
    friend_ids = Member.where('user_id <> ?', @user.id)
      .group('user_id')
      .count('id')
      .map{ |x| x[0]}
      .to_a

    # Get all groups which were created by the user or which were joined by the user
    group_ids = (Group.all.where(owner: @user.id) + Member.where(:user_id => @user.id).map { |member| member.group }).
        map { |group| group.id }.
        uniq { |id| id }

    # Get all the groups which the user is not a part of, but his friends are
    suggested = Member.where('user_id in (?) and group_id not in (?)', friend_ids, group_ids)
      .group('group_id')
      .count('id')
      .map{ |x| x[0]}
      .to_a[0..5]

    respond_to do |format|
      format.json do
        render json: suggested.map{|id|
          {
              :id => "/groups/#{id}",
              :links => [
                  link('group_info', 'GET', "/groups/#{id}.json"),
                  link('join_info', 'GET', "/groups/#{id}/join.json")
              ]
          }
        }
      end
    end


  end
end
