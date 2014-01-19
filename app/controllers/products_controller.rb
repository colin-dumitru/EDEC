require 'dydra_impl'

class ProductsController < ApplicationController
  include ApplicationHelper
  include SparqlHelper

  before_action :check_authenticated, :only => [:verdict]

  def show
    product = Product.find(params[:id])

    respond_to do |format|
      format.json do
        render json: {
            :name => product.name,
            :image => product.image,
            :ingredients => product.ingredients.map { |id|
              {
                  :id => "/ingredients/#{id}",
                  :links => [
                      link('ingredient_info', 'GET', "/ingredients/#{id}.json")
                  ]
              }
            },
            :company => {
                :id => "/companies/#{product.company_id}",
                :links => [
                    link('company_info', 'GET', "/companies/#{product.company_id}.json")
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
    product = Product.find(params[:id])

    # company which made the product
    companies = [product.company_id]
    # product ingredients
    ingredients = product.ingredients
    # add companies which made the ingredients
    ingr_query = "PREFIX i:<http://edec.org/ingredient/>
                  SELECT DISTINCT *
                  WHERE {
                    ?s <http://edec.org/madeBy> ?o FILTER (?s in (#{ingredients.map { |i| "i:#{i}" }.join(',')}))
                  }"

    companies = (companies + $d.query(ingr_query).map { |binding|
      rid(binding['o']['value'], 'company')
    }).uniq { |id| id }

    # Get all the blacklisted items for the user (groups which he has joined or created)
    rules = (Group.all.where(owner: @user.id) + Member.where(:user_id => @user.id).map { |member| member.group }).
        map { |group| group.rules }.
        flatten.
        map { |rule| {item: rule.item_id, filter: rule.filter_reason_id} }

    # Create a list with all possible blacklist items
    black_items = %W(/products/#{product.id}) +
        ingredients.map { |id| "/ingredients/#{id}" } +
        companies.map { |id| "/companies/#{id}" }

    # Select only rules which have a blacklist item from the above list
    reasons = rules.select{|rule|
      black_items.include? rule[:item]
    }.map {|rule| rule[:filter]}.uniq{|id| id}

    respond_to do |format|
      format.json do
        render json: {
            :status => reasons.empty? ? 'green' : 'red',
            :reasons => reasons.map{|id| "/filter_reasons/#{id}"}
        }
      end
    end
  end
end
