module DydraHelper
  def self.bind_value (bindings, key)
    binding = bindings.select { |binding|
      binding['p']['value'] == "http://edec.org/#{key}"
    }.first

    if binding
      binding['o']['value']
    else
      nil
    end
  end

  def bind_value (bindings, key)
    DydraHelper.bind_value(bindings, key)
  end

  def self.rid (resource, type)
    if resource
      resource.match("#{type}/(.*)").captures[0]
    else
      nil
    end
  end

  def rid(resource, type)
    DydraHelper.rid(resource, type)
  end
end
