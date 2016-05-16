class SalelasttimeController < Sinatra::Base

  get '/' do
    lastsale = Sale.where("type = ?","P").last
	unless lastsale
      lastsale = Allsale.where("type = ?","P").last    
    end
    lastsale.to_json
  end

end