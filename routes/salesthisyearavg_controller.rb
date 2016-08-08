class SalesthisyearavgController < Sinatra::Base

  get '/' do
    salesthisyear = Archivesale.where("type = ?","P").sum("totalprice") + 2400 # 2400 is missing data from feb 2016
    
    numberofmonths = (Archivesale.where("type = ?","P").group_by_month(:date).count.size) - 1 # -1 to remove Oct 2015 days
    
    #numberofdays = Allsale.where("type = ?","P").group_by_day(:date).count.size
    #salestoday = Eodlog.last.ntxbtotval if salestoday == "0.0"
    
    salesthisyearavg = salesthisyear.to_f/numberofmonths
	    
    #if Sale.count > 0 || (Time.now.hour > 0 && Time.now.hour < 9)
    #  salesthismonthavg = salesthismonth.to_f/(Time.now.day - 1) 
    #else
    #  salesthismonthavg = salesthismonth.to_f/(Time.now.day)
    #end
    salesthisyearavg.to_i.to_s
  end

end