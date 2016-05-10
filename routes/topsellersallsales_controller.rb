class TopsellersallsalesController < Sinatra::Base

  get '/' do
    #topsellers_allsales = Allsale.where("type = ?","P").group(:plu).sum(:qty)
    #topsellers_allsales_qty = Allsale.where("type = ?","P").group(:description).sum(:qty).sort_by{|_key, value| value}
    #topsellers_allsales_qty.last
    #topsellers_allsales_qty.last.to_i
    @topsellers_value = Allsale.where("type = ?","P").group(:description).sum(:totalprice).sort_by{|_key, value| value}.reverse
    {"items" =>
	    [{"label" => @topsellers_value[0][0],"value" => "£" + "#{@topsellers_value[0][1].round}"},
	     {"label" => @topsellers_value[1][0],"value" => "£" + "#{@topsellers_value[1][1].round}"},
	     {"label" => @topsellers_value[2][0],"value" => "£" + "#{@topsellers_value[2][1].round}"},
	     {"label" => @topsellers_value[3][0],"value" => "£" + "#{@topsellers_value[3][1].round}"},
	     {"label" => @topsellers_value[4][0],"value" => "£" + "#{@topsellers_value[4][1].round}"},
	     {"label" => @topsellers_value[5][0],"value" => "£" + "#{@topsellers_value[5][1].round}"},
	     {"label" => @topsellers_value[6][0],"value" => "£" + "#{@topsellers_value[6][1].round}"}
	    ]}.to_json
    
   
  end

end