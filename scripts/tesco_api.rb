require 'net/http'

class Tescosearch  
  
  def self.name(desc) 
    $uri = URI("https://dev.tescolabs.com/grocery/products/?query=#{URI.escape(desc)}&offset=0&limit=2")
    request = Net::HTTP::Get.new($uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = '5164f9b5ce6548fe9bc323fa2bf74cfa'
    # Request body
    request.body = "{body}"
    
    $response = Net::HTTP.start($uri.host, $uri.port, :use_ssl => $uri.scheme == 'https') do |http|
      http.request(request)
    end
         
    $uri.query = URI.encode_www_form({query: desc, offset: 0, limit: 2})
    @tesco_name1 = JSON.parse($response.body)["uk"]["ghs"]["products"]["results"][0]["name"]
    @tesco_name2 = JSON.parse($response.body)["uk"]["ghs"]["products"]["results"][1]["name"]
  end
  
  def self.price(desc)  
    $uri = URI("https://dev.tescolabs.com/grocery/products/?query=#{URI.escape(desc)}&offset=0&limit=2")
    request = Net::HTTP::Get.new($uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = '5164f9b5ce6548fe9bc323fa2bf74cfa'
    # Request body
    request.body = "{body}"
    
    $response = Net::HTTP.start($uri.host, $uri.port, :use_ssl => $uri.scheme == 'https') do |http|
      http.request(request)
    end
         
    $uri.query = URI.encode_www_form({query: desc, offset: 0, limit: 2})
    @tesco_price1 = JSON.parse($response.body)["uk"]["ghs"]["products"]["results"][0]["price"]
    @tesco_price2 = JSON.parse($response.body)["uk"]["ghs"]["products"]["results"][1]["price"]
  end
    
end

#Tescosearch.name("Diet coke")

