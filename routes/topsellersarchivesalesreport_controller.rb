class TopsellersarchivesalesreportController < Sinatra::Base

  get '/' do
    #@topsellers_value_archive = Archivesale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
    #@topsellers_value_allsales = Allsale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
    #@topsellers_value_sales = Sale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
    #
    #@topsellers_value = @topsellers_value_archive.merge(@topsellers_value_allsales){ |k, a_value, b_value| a_value + b_value }.merge(@topsellers_value_sales){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
    
    @topsellers_value_archive = Archivesale.where("type = ?","P").group(:plu)
    @topsellers_value_allsales = Allsale.where("type = ?","P").group(:plu)
    @topsellers_value_sales = Sale.where("type = ?","P").group(:plu)
    
    @topsellers_value = @topsellers_value_sales.sum(:totalprice).merge(@topsellers_value_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(@topsellers_value_archive.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
    
    @topsellers_qty = @topsellers_value_sales.sum(:qty).merge(@topsellers_value_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(@topsellers_value_archive.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse         
                   
    #@topsellers_qty = Archivesale.where("type = ?","P").group(:plu).sum(:qty)
    
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
    
    @thismonthsalestotal = Allsale.where("type = ?","P").sum("totalprice")
    
    @salestotal = (Archivesale.where("type = ?","P").sum("totalprice") + @thismonthsalestotal).to_i
    @report_time = "Since 28 Oct 2015"
    haml :topsellers
    
  end

end