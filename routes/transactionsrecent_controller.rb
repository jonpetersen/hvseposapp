class TransactionsrecentController < Sinatra::Base

  get '/' do
    mins = 10
    
    if mins.minutes.ago.min < 10
	  minstring = "0" + mins.minutes.ago.min.to_s
    else
      minstring = mins.minutes.ago.min.to_s
    end
    
    if mins.minutes.ago.hour < 10
	  hourstring = "0" + mins.minutes.ago.hour.to_s
    else
      hourstring = mins.minutes.ago.hour.to_s
    end
    
    timeago = hourstring + ":" + minstring
       
    salesrecent = Sale.where("time >= ? AND type = ? AND first = ?",timeago,"P",1).count
    
    
    salesrecent.to_json
  end

end