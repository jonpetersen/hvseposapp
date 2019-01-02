class TopsellersyearsalesreportController < Sinatra::Base

  get '/' do    
    if params[:yyyy]
      @salesyear = Date.strptime(params[:yyyy], "%Y").strftime("%Y")
      @periodforreport = @salesyear
      #@salesyear = "current" if params[:yyyy] == "2018"
      start_month = @salesyear + "-02-01"
	  end_month = (@salesyear.to_i + 1).to_s + "-01-31"
    end
            
    @topsellers_value = Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month).group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
        
    @topsellers_qty = Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month).group(:plu).sum(:qty)
    
    @topsellers = []
    @topsellers_value.each do |item|
	  itemqty = @topsellers_qty.detect {|key, val| key == item[0]}
      stockitem = Stock.where("plu = ?",item[0]).first
      itemdetails = Stock.joins(:depart).where("plu = ?", item[0]).first
      if itemdetails
        itemdept = itemdetails.depart.desc
        itemgroup = Depart.where("gid = ?",itemdetails.depart)[0].group.desc
	  else
	    itemdept = "NO DEPT FOR THIS ITEM"
      end  
      if stockitem
        itemdesc = stockitem.desc
      else
        itemdesc = "NOT IN STOCK DATABASE"
      end
      @topsellers << [itemdesc,item[0],item[1],itemqty[1],itemdept,itemgroup]
    end
        
    @salestotal = Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month).sum("totalprice")
    @report_time = @salesyear
    haml :topsellersyear
    
  end

end