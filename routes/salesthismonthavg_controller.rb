class SalesthismonthavgController < Sinatra::Base

  get '/' do
    salesthismonth = Allsale.where("type = ?","P").sum("totalprice")
    
    numberofdays = Allsale.where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group_by_day(:date).count.size
    
    #numberofdays = Allsale.where("type = ?","P").group_by_day(:date).count.size
    #salestoday = Eodlog.last.ntxbtotval if salestoday == "0.0"
    
    salesthismonthavg = salesthismonth.to_f/numberofdays
	    
    #if Sale.count > 0 || (Time.now.hour > 0 && Time.now.hour < 9)
    #  salesthismonthavg = salesthismonth.to_f/(Time.now.day - 1) 
    #else
    #  salesthismonthavg = salesthismonth.to_f/(Time.now.day)
    #end
    salesthismonthavg.to_i.to_s
  end

end