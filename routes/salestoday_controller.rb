class SalestodayController < Sinatra::Base

  get '/' do
    salestoday = Sale.where("type = ?","P").sum("totalprice").to_json
    salestoday = Eodlog.last.ntxbtotval if salestoday == "0.0"
    salestoday.to_s
  end

end