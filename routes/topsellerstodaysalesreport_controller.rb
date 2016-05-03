class TopsellerstodaysalesreportController < Sinatra::Base

  get '/' do
    @topsellers_value = Sale.where("type = ?","P").group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
    
    if @topsellers_value.empty?
	  allsales_lastdate = Allsale.last.date 
	  @topsellers_value = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:plu).sum(:totalprice).sort_by{|_key, value| value}.reverse
	  @topsellers_qty = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:plu).sum(:qty)   
	end
    
    #@topsellers_valuesum = Sale.where("type = ?","P").sum(:totalprice)
    
    @topsellers = []
    @topsellers_value.each do |item|
	  itemqty = @topsellers_qty.detect {|key, val| key == item[0]}
      itemdesc = Stock.where("plu = ?",item[0]).first.desc
      @topsellers << [itemdesc,item[0],item[1],itemqty[1]]
    end
    
    @report_time = "Today"
    haml :topsellers   
  end

end