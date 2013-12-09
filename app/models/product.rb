require 'dydra_impl'

class Product
  include DydraHelper

  attr_accessor :id
  attr_accessor :company_id
  attr_accessor :image
  attr_accessor :ingredients
  attr_accessor :name

  def initialize (id, company_id, image, name, ingredients)
    @id = id
    @name = name
    @company_id = company_id
    @image = image
    @ingredients = ingredients
  end

  def self.find(id)
    bindings = $d.resource(id, 'product')
    company_id = DydraHelper.rid(DydraHelper.bind_value(bindings, 'madeBy'), 'company')
    name = DydraHelper.bind_value(bindings, 'name')

    ingredients_query = "PREFIX p:<http://edec.org/product/>
                      SELECT *
                      WHERE {
                               p:#{id} <http://edec.org/hasIngredient> ?o
                      }"

    ingredients = $d.query(ingredients_query).map { |binding|
      DydraHelper.rid(binding['o']['value'], 'ingredient')
    }

    Product.new(id, company_id, 'Irigna forgot to add an image', name, ingredients)
  end

  def self.bind_value (bindings, key)
    bindings.select { |binding|
      binding['p']['value'] == "http://edec.org/#{key}"
    }.first['o']['value']
  end
end