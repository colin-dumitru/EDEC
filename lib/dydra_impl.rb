require 'dydra'

class DydraImpl
  attr_accessor :repository

  def initialize
    Dydra.setup!(:token => 'AYbOx0Fp8kchdQ1pNmxF')

    @account = Dydra::Account.new('extravenos')
    @repository = @account['edec']
  end

  def resource(id, type)
    result = @repository.query("PREFIX i:<http://edec.org/#{type}/>
          SELECT *
          WHERE { i:#{id} ?p ?o }")
    JSON.parse(result)['results']['bindings']
  end

  def search_by_name(name, type)
    result = @repository.query("PREFIX i:<http://edec.org/#{type}/>
          SELECT *
          WHERE {
                   ?s <http://edec.org/name> ?o FILTER (regex(str(?s), 'edec.org/#{type}') && regex(str(?o), '#{name}', 'i'))
          }"
    )
    JSON.parse(result)['results']['bindings']
  end

  def query(query)
    result = @repository.query(query)
    JSON.parse(result)['results']['bindings']
  end
end

$d = DydraImpl.new
