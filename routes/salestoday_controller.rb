class SalestodayController < Sinatra::Base

  get '/' do
    if Eodlog.last.dtlastedit.today?
      salestoday = Eodlog.last.ntxbtotval
    else
      salestoday = Sale.where("type = ?","P").sum("totalprice")
    end        
    salestoday.to_s
  end

end