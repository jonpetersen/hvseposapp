class StockitemController < Sinatra::Base

  get '/:plu' do
	  
	# plu = "90207"  
	  
    plu=params[:plu]
    @stockitem = Stock.joins(:depart).where("plu = ?",plu).first
    #@stock_item_depart = @stockitem.depart.desc
    
    #historical sales
    sales = Sale.joins(:stock).where("type = ? AND sales.plu = ?","P",plu)
    allsales = Allsale.joins(:stock).where("type = ? AND allsales.plu = ?","P",plu)
    archivesales = Archivesale.joins(:stock).where("type = ? AND archivesales.plu = ?","P",plu)
    
    @item_total_qtysold = sales.sum(:qty).to_i + allsales.sum(:qty).to_i + archivesales.sum(:qty).to_i

    item_total_qtysold_by_day = archivesales.group_by_day(:created_at).count.merge(allsales.group_by_day(:created_at).count).merge(sales.group_by_day(:created_at).count)
    @item_total_qtysold_by_week = archivesales.group_by_week(:created_at).count.merge(allsales.group_by_week(:created_at).count).merge(sales.group_by_week(:created_at).count)
        
    #item_everysale = Archivesale.all.union(Allsale.all).union(Sale.all).where("type = ? AND plu = ?","P",plu)
    
    #item_total_qtysold_by_day = item_everysale.group_by_day(:date).count
    @item_total_qtysold_last30days = item_total_qtysold_by_day.to_a.last(30)
    
    #@item_total_qtysold_by_week = item_everysale.group_by_week(:date).count.to_a
    
    haml :stockitem
    
  end

end