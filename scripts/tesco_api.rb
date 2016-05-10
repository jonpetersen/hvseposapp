require 'net/http'

uri = URI('https://dev.tescolabs.com/grocery/products/?query=bread&offset=0&limit=10')
uri.query = URI.encode_www_form({query: "Milky Way 21.5g", offset: 0, limit: 10})

request = Net::HTTP::Get.new(uri.request_uri)
# Request headers
request['Ocp-Apim-Subscription-Key'] = '5164f9b5ce6548fe9bc323fa2bf74cfa'
# Request body
request.body = "{body}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body

