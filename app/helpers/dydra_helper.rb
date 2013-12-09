module DydraHelper
  def self.bind_value (bindings, key)
    bindings.select { |binding|
      binding['p']['value'] == "http://edec.org/#{key}"
    }.first['o']['value']
  end

  def bind_value (bindings, key)
    DydraHelper.bind_value(bindings, key)
  end

  def self.rid (resource, type)
    resource.match("#{type}/(.*)").captures[0]
  end

  def rid(resource, type)
    DydraHelper.rid(resource, type)
  end
end
