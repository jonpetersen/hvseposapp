class SalesactivityController < Sinatra::Base

  get '/' do
	  	      
    #everysale = Archivesale.all.union(Allsale.all).union(Sale.all).where("type = ?","P")    
    archivesales = Archivesale.all.where("type = ?","P")
    allsales = Allsale.all.where("type = ?","P")
    sales = Sale.all.where("type = ?","P")
    
    
    #merge order changed because April 30th data in archive and allsales
    @activitybymonth = sales.group_by_month(:created_at).count.merge(allsales.group_by_month(:created_at).count).merge(archivesales.group_by_month(:created_at).count).sort_by{|k,v| k}
    @activitybyweek = sales.group_by_week(:created_at).count.merge(allsales.group_by_week(:created_at).count).merge(archivesales.group_by_week(:created_at).count).sort_by{|k,v| k}
    @activitybyday = sales.group_by_day(:created_at).count.merge(allsales.group_by_day(:created_at).count).merge(archivesales.group_by_day(:created_at).count).sort_by{|k,v| k}.last(31)
    
    #merge order changed because sales may contain a few items form previous days (paid IOU's?)
    activitybyhour = sales.group_by_hour(:created_at).count.merge(allsales.group_by_hour(:created_at).count).merge(archivesales.group_by_hour(:created_at).count).sort_by{|k,v| k}
    @activitybyhour_lastweek = activitybyhour.last(24 * 7)
    @activitybyhour_today = activitybyhour.select{|key, hash| key.to_date.today?}   

    if params[:output] == "json"
	  #Hash[activitybyhour.map{|k,v| [k.time.to_i,v] } ].to_json
      # Adjust by UTC offset for BST becasue all RDS times are GMT/BST times stored as UTC
      activitybyhour_last = Hash[activitybyhour.last(24 * 90)]
      Hash[activitybyhour_last.map{|k,v| [(k.time.to_i - k.to_time.utc_offset),v] } ].to_json
      
    else
      haml :salesactivity
    end
    
  end

end