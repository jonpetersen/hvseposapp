class TopsellerstodaysalesController < Sinatra::Base

  get '/' do
    #topsellers_allsales = Allsale.where("type = ?","P").group(:plu).sum(:qty)
    #topsellers_allsales_qty = Allsale.where("type = ?","P").group(:description).sum(:qty).sort_by{|_key, value| value}
    #topsellers_allsales_qty.last
    #topsellers_allsales_qty.last.to_i
    
    allsales_lastdate = Allsale.last.date
        
    if Sale.count == 0 || allsales_lastdate.today?
	  @topsellers_value = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:description).sum(:totalprice).sort_by{|_key, value| value}.reverse
	else
	  @topsellers_value = Sale.where("type = ?","P").group(:description).sum(:totalprice).sort_by{|_key, value| value}.reverse
	end     
    items_array = []
	n = 7
	n = @topsellers_value.size unless @topsellers_value.size > 7
	for i in 0...n
	  items_array << {"label" => @topsellers_value[i][0],"value" => "£" + "#{@topsellers_value[i][1].round}"}
	end
      
    {"items" => items_array}.to_json
   
  end

end