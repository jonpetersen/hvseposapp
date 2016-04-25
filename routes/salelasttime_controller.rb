class SalelasttimeController < Sinatra::Base

  get '/' do
    lastsale = Sale.where("type = ?","P").last
	if lastsale
      lastsale = Sale.where("type = ?","P").last
      lastsale.to_json
    else
      "EOD"
    end
  end

end