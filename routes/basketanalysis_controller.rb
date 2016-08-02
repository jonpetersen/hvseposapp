class BasketanalysisController < Sinatra::Base

  get '/' do
  	
  	sales_transactions = Sale.where("type = ?","P").group(:transno)
  	allsales_transactions = Allsale.where("type = ?","P").group(:transno)
  	#archivesales_transactions = Archivesale.where("type = ?","P").group(:transno)
  	
  	sales_transactions_array = []
  	allsales_transactions_array = []
  	
  	sales_transactions.each do |t|
	  items = Sale.where("transno = ? AND type = ?",t.transno,"P")	
	  items_array = []
	  items.each do |i|      
        items_array << i.description
      end
      sales_transactions_array << items_array.uniq
    end
    
    allsales_transactions.each do |t|
	  items = Allsale.where("transno = ? AND type = ?",t.transno,"P")	
	  items_array = []
	  items.each do |i|      
        items_array << i.description
      end
      allsales_transactions_array << items_array.uniq
    end
    
    
    transactions_array = sales_transactions_array + allsales_transactions_array
    
    test_data = transactions_array
    item_set = Apriori::ItemSet.new(test_data)
    support = 1
    confidence = 1
    item_set.mine(support, confidence)
        
    # not built yet
    haml :transactions
    
  end

end