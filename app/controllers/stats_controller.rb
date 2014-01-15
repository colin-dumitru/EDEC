class StatsController < ApplicationController
  include ApplicationHelper

  def ingredients
    @ingredients = Rule.
        where('lower(item_id) like \'%ingredients%\'').
        group('item_id').
        count('id')

    @ingredients = @ingredients.
        to_a.
        sort_by { |k, v| v }.
        reverse

    respond_to do |format|
      format.json do
        render json: @ingredients[0..2].map{|ingredient|
          {
              :id => "#{ingredient[0]}",
              :links => [
                  link('ingredient_info', 'GET', "#{ingredient[0]}.json")
              ]
          }
        }
      end
    end
  end

  def products
    @products = Rule.
        where('lower(item_id) like \'%products%\'').
        group('item_id').
        count('id')

    @products = @products.
        to_a.
        sort_by { |k, v| v }.
        reverse

    respond_to do |format|
      format.json do
        render json: @products[0..2].map{|product|
          {
              :id => "#{product[0]}",
              :links => [
                  link('product_info', 'GET', "#{product[0]}.json")
              ]
          }
        }
      end
    end
  end

  def companies
    @companies = Rule.
        where('lower(item_id) like \'%companies%\'').
        group('item_id').
        count('id')

    @companies = @companies.
        to_a.
        sort_by { |k, v| v }.
        reverse

    respond_to do |format|
      format.json do
        render json: @companies[0..2].map{|company|
          {
              :id => "#{company[0]}",
              :links => [
                  link('company_info', 'GET', "#{company[0]}.json")
              ]
          }
        }
      end
    end
  end
end
