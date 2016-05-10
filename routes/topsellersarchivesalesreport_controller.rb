class TopsellersarchivesalesreportController < Sinatra::Base

  get '/' do
    @topsellers_value = Archivesale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
    
    @topsellers_qty = Archivesale.where("type = ?","P").group(:plu).sum(:qty)
    
    @topsellers = []
    @topsellers_value.each do |item|
	  itemqty = @topsellers_qty.detect {|key, val| key == item[0]}
      stockitem = Stock.where("plu = ?",item[0]).first
      itemdept = Stock.joins(:depart).where("plu = ?", item[0]).first
      if itemdept
        itemdept = itemdept.depart.desc
	  else
	    itemdept = "NO DEPT FOR THIS ITEM"
      end  
      if stockitem
        itemdesc = stockitem.desc
      else
        itemdesc = "NOT IN STOCK DATABASE"
      end
      @topsellers << [itemdesc,item[0],item[1],itemqty[1],itemdept]
    end
    @salestotal = Archivesale.where("type = ?","P").sum("totalprice")
    @report_time = "All"
    haml :topsellers
    
  end

end