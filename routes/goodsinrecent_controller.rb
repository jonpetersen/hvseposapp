class GoodsinrecentController < Sinatra::Base

  get '/' do
    
    if Time.now.day < 10
	  daystring = "0" + Time.now.day.to_s
    else
      daystring = Time.now.day.to_s
    end
    
    if Time.now.month < 10
	  monthstring = "0" + Time.now.month.to_s
    else
      monthstring = Time.now.month.to_s
    end
    
    yearstring = Time.now.year.to_s
    
    date_string = yearstring + "-" + monthstring + "-" + daystring
       
    goodsinrecent = Inward.where("date_in = ?",date_string).count
    goodsinrecent.to_json
  end

end