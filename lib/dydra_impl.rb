require 'net/http'

class DydraImpl
  attr_accessor :repository

  def initialize
  end

  def resource(id, type)
    query("PREFIX i:<http://edec.org/#{type}/>
          SELECT *
          WHERE { i:#{id} ?p ?o }")
  end

  def search_by_name(name, type)
    query("PREFIX i:<http://edec.org/#{type}/>
          SELECT *
          WHERE {
                   ?s <http://edec.org/name> ?o FILTER (regex(str(?s), 'edec.org/#{type}') && regex(str(?o), '#{name}', 'i'))
          }"
    )
  end

  def query(query)
    url = "http://edec-rdf.herokuapp.com/edec/sparql?query=#{URI.escape(query)}&output=json"
    JSON.parse(
        Net::HTTP.get(URI.parse(url))
    )['results']['bindings']
  end
end

$d = DydraImpl.new
