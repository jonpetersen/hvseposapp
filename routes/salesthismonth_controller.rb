class SalesthismonthController < Sinatra::Base

  get '/' do
    salesthismonth = Allsale.where("type = ?","P").sum("totalprice").to_json
    #salestoday = Eodlog.last.ntxbtotval if salestoday == "0.0"
    salesthismonth.to_i.to_s
  end

end