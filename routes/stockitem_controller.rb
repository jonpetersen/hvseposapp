class StockitemController < Sinatra::Base

  get '/:plu' do
    @plu=params[:plu]
    @stockitem = Stock.joins(:depart).where("plu = ?",@plu).first
    #@stock_item_depart = @stockitem.depart.desc
    
    haml :stockitem
    
  end

end