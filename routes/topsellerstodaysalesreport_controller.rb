class TopsellerstodaysalesreportController < Sinatra::Base

  get '/' do
    #topsellers_allsales = Allsale.where("type = ?","P").group(:plu).sum(:qty)
    #topsellers_allsales_qty = Allsale.where("type = ?","P").group(:description).sum(:qty).sort_by{|_key, value| value}
    #topsellers_allsales_qty.last
    #topsellers_allsales_qty.last.to_i
    @topsellers_value = Sale.where("type = ?","P").group(:description).sum(:totalprice).sort_by{|_key, value| value}.reverse
    @topsellers_qty = Sale.where("type = ?","P").group(:description).sum(:qty)
    @topsellers_valuesum = Sale.where("type = ?","P").sum(:totalprice)
    @topsellers = []
    @topsellers_value.each do |item|
	  itemqty = @topsellers_qty.detect {|key, val| key == item[0]}
      @topsellers << [item[0],item[1],itemqty[1]]
    end
    
    @report_time = "Today"
    haml :topsellers   
  end

end