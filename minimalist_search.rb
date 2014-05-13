class MinimalistSearch < Sinatra::Application
  before do
    content_type 'application/json'
  end
  get '/search' do
    headers( "Access-Control-Allow-Origin" => "*" )
    headers( "Access-Control-Request-Method" => "*" )
    term = params['term']
    client = Elasticsearch::Client.new log: true
    results = client.search q: params['term']
    n = results["hits"]["hits"].collect.with_index do |ci,i|
      {id: ci["_id"],
       value: ci["_source"]["name"],
       description: ci["_source"]["description"]
      }
    end.to_json
  end
end