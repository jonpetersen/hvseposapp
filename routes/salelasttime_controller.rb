class SalelasttimeController < Sinatra::Base

  get '/' do
    lastsale = Sale.where("type = ?","P").last
	allsales_lastdate = Date.parse("1 Jan 2000")
	allsales_lastdate = Allsale.last.date if Allsale.last
	if lastsale.nil? || allsales_lastdate.today?
      #lastsale = Allsale.where("type = ?","P").last
      lastsale = "EOD"     
    else 
      lastsale = lastsale.to_json
    end
    lastsale
  end

end