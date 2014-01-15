class FilterReasonsController < ApplicationController
  include ApplicationHelper

  def index
    @reasons = FilterReason.all

    respond_to do |format|
      format.json do
        render json: @reasons.map { |reason|
          {
              :id => "/filter_reasons/#{reason.id}",
              :for_resource => reason.for_resource,
              :short_description => reason.short_description,
              :links => [
                  link('reason_info', 'GET', '/filter_reasons/1.json')
              ]
          }
        }
      end
    end
  end

  def show
    @reason = FilterReason.find(params[:id])

    respond_to do |format|
      format.json do
        render json: {
            :id => "/filter_reasons/#{@reason.id}",
            :for_resource => @reason.for_resource,
            :short_description => @reason.short_description
        }
      end
    end

  end

end
