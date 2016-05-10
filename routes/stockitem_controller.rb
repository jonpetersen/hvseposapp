class StockitemController < Sinatra::Base

  get '/:plu' do
	  
	# @plu = "90207"  
	  
    @plu=params[:plu]
    @stockitem = Stock.joins(:depart).where("plu = ?",@plu).first
    #@stock_item_depart = @stockitem.depart.desc
    
    #historical sales
    @salesforplu = Sale.joins(:stock).where("type = ? AND sales.plu = ?","P",@plu)
    @allsalesforplu = Allsale.joins(:stock).where("type = ? AND allsales.plu = ?","P",@plu)
    @archivesalesforplu = Archivesale.joins(:stock).where("type = ? AND archivesales.plu = ?","P",@plu)
    
    item_everysale = Archivesale.all.union(Allsale.all).union(Sale.all).where("type = ? AND plu = ?","P",@plu)
    @item_total_qtysold = item_everysale.sum(:qty).to_i
    
    item_total_qtysold_by_day = item_everysale.group_by_day(:date).count
    @item_total_qtysold_last30days = item_total_qtysold_by_day.to_a.last(30)
    
    @item_total_qtysold_by_week = item_everysale.group_by_week(:date).count.to_a
    
    haml :stockitem
    
  end

end