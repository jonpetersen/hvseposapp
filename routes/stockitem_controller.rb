class StockitemController < Sinatra::Base
  
  get '/:plu' do
	require "./scripts/tesco_api.rb"
	  
	# plu = "90207"  
	  
    plu=params[:plu]
    @stockitem = Stock.joins(:depart).where("plu = ?",plu).first
    #@stock_item_depart = @stockitem.depart.desc
    
    unless @stockitem.vatrate
	  if @stockitem.vatcode == 2
	    @stockitem.vatrate = 0
	  else
        @stockitem.vatrate = 20
      end
    end
    
    #historical sales
    sales = Sale.joins(:stock).where("type = ? AND sales.plu = ?","P",plu)
    allsales = Allsale.joins(:stock).where("type = ? AND allsales.plu = ?","P",plu)
    archivesales = Archivesale.joins(:stock).where("type = ? AND archivesales.plu = ?","P",plu)
    
    @item_total_qtysold = sales.sum(:qty).to_i + allsales.sum(:qty).to_i + archivesales.sum(:qty).to_i
    
    #use range on allsales and archivesales to get 0 values returned by groupdate for charting
    
    item_total_qtysold_by_day_allsales = allsales.group_by_day(:created_at,dates: true, range: (Time.now.mday - 1).days.ago.midnight..Time.now).sum(:qty)
    item_total_qtysold_by_day_archivesales = archivesales.group_by_day(:created_at,dates: true, range: Time.parse("28 Oct 2015")..Time.now).sum(:qty)
    item_total_qtysold_by_day_sales = sales.group_by_day(:created_at,dates: true,last: 1).sum(:qty)
    
    item_total_qtysold_by_day = item_total_qtysold_by_day_archivesales.merge(item_total_qtysold_by_day_allsales){|key, oldval, newval| newval + oldval}.merge(item_total_qtysold_by_day_sales){|key, oldval, newval| newval + oldval}
        
    #sort into date order
    item_total_qtysold_by_day = item_total_qtysold_by_day.sort_by{|k,v| k}    
    
    item_total_qtysold_by_week_allsales = allsales.group_by_week(:created_at,dates: true, week_start: :mon, range: (Time.now.mday - 1).days.ago.midnight..Time.now).sum(:qty)
    item_total_qtysold_by_week_archivesales = archivesales.group_by_week(:created_at,dates: true,week_start: :mon, range: Time.parse("28 Oct 2015")..Time.now).sum(:qty)
    item_total_qtysold_by_week_sales = sales.group_by_week(:created_at,dates: true, week_start: :mon,last: 1).sum(:qty)
    
    @item_total_qtysold_by_week = item_total_qtysold_by_week_archivesales.merge(item_total_qtysold_by_week_allsales){|key, oldval, newval| newval + oldval}.merge(item_total_qtysold_by_week_sales){|key, oldval, newval| newval + oldval}        
    
    @item_total_qtysold_last30days = item_total_qtysold_by_day.to_a.last(30)
    
    #@item_total_qtysold_by_week = item_everysale.group_by_week(:date).count.to_a
    
    #TESCO API LOOKUP
    @tescosearch = Tesco.search(@stockitem.desc)
    if @tescosearch[0] 
	   @tescosearchname1 = @tescosearch[0]["name"]
	   @tescosearchprice1 = Money.new(@tescosearch[0]["price"]*100).format
	else
	  @tescosearchname1 = "Not found"
	  @tescosearchprice1 = "Not found"
	end
	
	if @tescosearch[1] 
	   @tescosearchname2 = @tescosearch[1]["name"]
	   @tescosearchprice2 = Money.new(@tescosearch[1]["price"]*100).format
	else
	  @tescosearchname2 = "Not found"
	  @tescosearchprice2 = "Not found"
	end
    
    haml :stockitem
    
  end

end