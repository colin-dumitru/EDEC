require 'dydra_impl'
require 'json'

class CompaniesController < ApplicationController
  include DydraHelper
  include ApplicationHelper

  def show
    bindings = $d.resource(params[:id], 'company')

    respond_to do |format|
      format.json do
         render json: {
             :name => bind_value(bindings, 'name'),
             :description => bind_value(bindings, 'description'),
             :logo => bind_value(bindings, 'logo')
         }
      end
    end
  end

  def search
    bindings = $d.search_by_name(params[:name], 'company')

    respond_to do |format|
      format.json do
        render json: bindings.map {|binding|
          id = rid(binding['s']['value'], 'company')
          {
              :id => "/companies/#{id}",
              :links => [
                  link('company_info', 'GET', "/companies/#{id}.json")
              ]
          }
        }
      end
    end
  end
end
