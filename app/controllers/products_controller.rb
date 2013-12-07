require 'dydra_impl'

class ProductsController < ApplicationController
  include ApplicationHelper
  include DydraHelper

  def show
    bindings = $d.resource(params[:id], 'ingredient')
    company_id = rid(bind_value(bindings, 'madeBy'), 'company')

    ingredients_query = "PREFIX p:<http://edec.org/product/>
                      SELECT *
                      WHERE {
                               p:#{params[:id]} <http://edec.org/hasIngredient> ?o
                      }"
    ingredients_bindings = $d.query(ingredients_query)

    respond_to do |format|
      format.json do
        render json: {
            :name => bind_value(bindings, 'name'),
            :image => 'Irina forgot to add an image',
            :ingredients => ingredients_bindings.map { |binding|
              id = rid(binding['o']['value'], 'ingredient')
              {
                  :id => "/ingredients/#{id}",
                  :links => [
                      link('ingredient_info', 'GET', "/ingredients/#{id}.json")
                  ]
              }
            },
            :company => {
                :id => "/companies/#{company_id}",
                :links => [
                    link('company_info', 'GET', "/companies/#{company_id}.json")
                ]
            }
        }
      end
    end
  end

  def search
    respond_to do |format|
      format.json do
        bindings = $d.search_by_name(params[:name], 'product')

        render json: bindings.map { |binding|
          id = rid(binding['s']['value'], 'product')

          {
              :id => "/products/#{id}",
              :links => [
                  link('product_info', 'GET', "/products/#{id}.json")
              ]
          }
        }
      end
    end
  end

  def similar
    query = "PREFIX v:<http://edec.org/product/>

            SELECT DISTINCT ?product
            WHERE {
                     v:#{params[:id]} <http://edec.org/type> ?type;
                           <http://edec.org/hasIngredient> ?ing.
                     ?product  <http://edec.org/type> ?type;
                                     <http://edec.org/hasIngredient> ?ingr.
                      FILTER ( ?product != v:1 &&   (?ingr IN (?ing) )  )
            }
             HAVING ( ( count(?ing)>=3 && count(?ingr)>=2 ) || (count(?ing)<3 ) )"

    bindings = $d.query(query)

    respond_to do |format|
      format.json do
        render json: bindings.map { |binding|
          id = rid(binding['product']['value'], 'product')

          {
              :id => id,
              :links => [
                  link('product_info', 'GET', "/products/#{id}.json")
              ]
          }
        }
      end
    end
  end

  def verdict

  end

end
