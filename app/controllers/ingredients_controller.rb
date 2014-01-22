require 'dydra_impl'
require 'json'

class IngredientsController < ApplicationController
  include SparqlHelper
  include ApplicationHelper

  def show
    bindings = $d.resource(params[:id], 'ingredient')
    company = rid( bind_value(bindings, 'Organization'), 'company')

    respond_to do |format|
      format.json do
        if company
          render json: {
              :name => bind_value(bindings, 'name'),
              :image => bind_value(bindings, 'image'),
              :company => "/companies/#{company}"
          }
        else
          render json: {
              :name => bind_value(bindings, 'name'),
              :image => bind_value(bindings, 'image')
          }
        end

      end
    end
  end

  def search
    bindings = $d.search_by_name(params[:name], 'ingredient')

    respond_to do |format|
      format.json do
        render json: bindings.map {|binding|
          id = rid(binding['s']['value'], 'ingredient')

          {
              :id => "/ingredients/#{id}",
              :links => [
                  link('ingredient_info', 'GET', "/ingredients/#{id}.json")
              ]
          }
        }
      end
    end
  end
end
