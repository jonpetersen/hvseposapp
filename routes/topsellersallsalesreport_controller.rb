class TopsellersallsalesreportController < Sinatra::Base

  get '/' do
    @topsellers_value = Allsale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
    
    @topsellers_qty = Allsale.where("type = ?","P").group(:plu).sum(:qty)
    
    @topsellers = []
    @topsellers_value.each do |item|
	  itemqty = @topsellers_qty.detect {|key, val| key == item[0]}
      itemdesc = Stock.where("plu = ?",item[0]).first.desc
      @topsellers << [itemdesc,item[0],item[1],itemqty[1]]
    end
    
    @report_time = "Month"
    haml :topsellers
    
   
  end

end