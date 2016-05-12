class SalesactivityController < Sinatra::Base

  get '/' do
	  	      
    #everysale = Archivesale.all.union(Allsale.all).union(Sale.all).where("type = ?","P")    
    archivesales = Archivesale.all.where("type = ?","P")
    allsales = Allsale.all.where("type = ?","P")
    sales = Sale.all.where("type = ?","P")
    
    @activitybymonth = archivesales.group_by_month(:created_at).count.merge(allsales.group_by_month(:created_at).count).merge(sales.group_by_month(:created_at).count)
    @activitybyweek = archivesales.group_by_week(:created_at).count.merge(allsales.group_by_week(:created_at).count).merge(sales.group_by_week(:created_at).count)
    @activitybyday = archivesales.group_by_day(:created_at).count.merge(allsales.group_by_day(:created_at).count).merge(sales.group_by_day(:created_at).count).to_a.last(31)
    
    activitybyhour = archivesales.group_by_hour(:created_at).count.merge(allsales.group_by_hour(:created_at).count).merge(sales.group_by_hour(:created_at).count)
    @activitybyhour_lastweek = activitybyhour.to_a.last(24 * 7)
    @activitybyhour_today = activitybyhour.select{|key, hash| key.to_date.today?}   

    if params[:output] == "json"
	  #Hash[activitybyhour.map{|k,v| [k.time.to_i,v] } ].to_json
      # Adjust by UTC offset for BST becasue all RDS times are GMT/BST times stored as UTC
      Hash[activitybyhour.map{|k,v| [(k.time.to_i - k.to_time.utc_offset),v] } ].to_json
      
    else
      haml :salesactivity
    end
    
  end

end