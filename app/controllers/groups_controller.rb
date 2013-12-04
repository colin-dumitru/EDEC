class GroupsController < ApplicationController
  include ApplicationHelper

  before_action :check_authenticated, :only => [:created, :joined, :join, :leave, :create, :update]

  def created
    @groups = Group.all

    respond_to do |format|
      format.json do
        render json: @groups.map { |group|
          {
              :id => "/groups/#{group.id}.json",
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
              :id => "/groups/#{group.id}.json",
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
            :id => "/groups/#{@group.id}.json",
            :title => @group.title,
            :logo => @group.logo,
            :description => @group.description,
            :rules => @rules.map { |rule|
              {
                  :item_id => rule.item_id,
                  :filter_reason_id => "/filter_reasons/#{rule.id}"
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
              :id => "/groups/#{group.id}.json",
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
            :id => "/groups/#{@group.id}.json",
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
            :id => "/groups/#{@group.id}.json",
            :links => [
                link('group_info', 'GET', "/groups/#{@group.id}.json"),
                link('delete_group', 'DELETE', "/groups/#{@group.id}.json")
            ]
        }
      end
    end
  end
end
