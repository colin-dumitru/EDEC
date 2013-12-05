module DydraHelper
  def bind_value (bindings, key)
    bindings.select { |binding|
      binding['p']['value'] == "http://edec.org/#{key}"
    }.first['o']['value']
  end

  def rid (resource, type)
    resource.match("#{type}/(.*)").captures[0]
  end
end
