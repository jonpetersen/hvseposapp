class BarcodeReportController < Sinatra::Base
  
  get '/' do
    #get details of stock items with alternative plu's in created range
    
    alternative_plus = Stockalt.joins(:stock).where("altsku > ?",5099999000000)
    
    #get details of stock items with plu's in created range
    
    created_plus = Stock.where("plu > ? AND plu < ?",5099999000000,5200000000000)
    
    #merge them
    
    @barcode_items = []
    
    alternative_plus.each do |item|
	  @barcode_items << [item.stock.desc, item.plu, item.altsku]   	    
	end
    
    created_plus.each do |item|
	  @barcode_items << [item.desc, item.plu, item.plu]   	    
	end
    
    haml :barcodelist
    
  end

end