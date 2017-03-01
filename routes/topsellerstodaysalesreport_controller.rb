class TopsellerstodaysalesreportController < Sinatra::Base

  get '/' do
    
    allsales_lastdate = Date.parse("1 Jan 2000")
    allsales_lastdate = Allsale.last.date if Allsale.last
        
    if Sale.count == 0 || allsales_lastdate.today?
	  @topsellers_value = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
	  @topsellers_qty = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:plu).sum(:qty)   
	else
	  @topsellers_value = Sale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
	  @topsellers_qty = Sale.where("type = ?","P").group(:plu).sum(:qty)   
	end
    
    #@topsellers_valuesum = Sale.where("type = ?","P").sum(:totalprice)

    @topsellers = []
    @topsellers_value.each do |item|
	  itemqty = @topsellers_qty.detect {|key, val| key == item[0]}
      stockitem = Stock.where("plu = ?",item[0]).first
      itemdept = Stock.joins(:depart).where("plu = ?", item[0]).first.depart.desc
	  if stockitem
        itemdesc = stockitem.desc
      else
        itemdesc = "NOT IN STOCK DATABASE"
      end
      @topsellers << [itemdesc,item[0],item[1],itemqty[1],itemdept]
    end
    
    @salestotal = Sale.where("type = ?","P").sum("totalprice")
    if @salestotal == 0
	  @salestotal = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).sum(:totalprice)    
	end
	    
    @report_time = "Today"
    haml :topsellers   
  end

end