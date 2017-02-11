class SalesthismonthController < Sinatra::Base

  get '/' do
    salesthismonth = Allsale.where("type = ?","P").sum("totalprice")
    salesthismonth = Sale.where("type = ?","P").sum("totalprice") if salesthismonth == 0
    salesthismonth.to_i.to_s
  end

end