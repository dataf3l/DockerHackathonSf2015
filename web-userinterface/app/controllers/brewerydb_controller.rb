# get '/brewerydb/*' do
#   path = params['splat'].first
#   response = HTTParty.get("http://api.brewerydb.com/v2/#{path}", query: params.merge(key:'ENV["SECRET_KEY"]'))
#   status response.code
#   response.body
# end

# get '/brewerydb/search' do
#   response = HTTParty.get("http://api.brewerydb.com/v2/search", query: params.merge(key:'c098f993b1b081a1ef1aa61078ac3503'))
#   status response.code
#   response.body
# end