require 'dydra_impl'
require 'json'

class IngredientsController < ApplicationController
  include DydraHelper
  include ApplicationHelper

  def show
    respond_to do |format|
      format.json do
        bindings = $d.resource(params[:id], 'ingredient')
        company = rid( bind_value(bindings, 'madeBy'), 'company')

         render json: {
             :name => bind_value(bindings, 'name'),
             :company => "/companies/#{company}"
         }
      end
    end
  end

  def search
    respond_to do |format|
      format.json do
        bindings = $d.search(params[:name], 'ingredient')

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
