class GroupsController < ApplicationController
  include ApplicationHelper

  before_action :check_authenticated, :only => [:created, :joined]

  def created
    @groups = Group.all

    respond_to do |format|
      format.json do
        render json: @groups.map {|group|
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
      .map {|member| member.group}

    respond_to do |format|
      format.json do
        render json: @groups.map {|group|
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
            :rules => @rules.map{|rule|
              {
                  :item_id => rule.item_id,
                  :filter_reason_id => "/filter_reasons/#{rule.id}"
              }
            },
            :links => [
                link('join_group', 'GET', "/groups/#{@group.id}.json/join.json"),
                link('leave_group', 'GET', "/groups/#{@group.id}.json/leave.json")
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
        render json: @groups.map {|group|
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

  end

  def leave

  end
end
