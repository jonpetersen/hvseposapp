class VattodayController < Sinatra::Base

  get '/' do
    vattoday = Sale.where("type = ?","P").sum("vatamount")
    vattoday = Eodlog.last.ntaxtotval if vattoday == 0
    
    salestoday = Sale.where("type = ?","P").sum("totalprice")    
    salestoday = Eodlog.last.ntxbtotval if salestoday == 0
    
    vatpercenttoday = (vattoday/salestoday)*100
    vatpercenttoday.round(1).to_s
  end

end