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
    support = 50
    confidence = 60
    item_set.mine(support, confidence)
    
    
  	if params[:n]
  	
  	  n=params[:n].to_i
      
      sales_transactions = Sale.where("type = ?","P").group(:transno).last(n)    
      
      if sales_transactions.empty?
	    allsales_lastdate = Allsale.last.date 
	    lastn_transactions = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:transno).last(n)
	  else
	    lastn_transactions = sales_transactions  
	  end
      
    else
      sales_transactions = Sale.where("type = ?","P").group(:transno)    
      
      if sales_transactions.empty?
	    allsales_lastdate = Allsale.last.date 
	    lastn_transactions = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:transno)
	    @sales_value = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).sum(:totalprice)
	  else
	    @sales_value = Sale.where("type = ?","P").sum(:totalprice)
	    lastn_transactions = sales_transactions
	  end      
    end
            
    @last_n_transactions_array = []
    
    lastn_transactions.each do |t|
  	  item_array = [] 
  	  if sales_transactions.empty?
  	    items = Allsale.where("transno = ? AND type = ? AND date = ?",t.transno,"P",allsales_lastdate)
      else
        items = Sale.where("transno = ? AND type = ?",t.transno,"P")
      end
      items.each do |i|      
        item_array << [i.description, i.totalprice.to_f, i.qty]
      end
      
      transvalue = items.sum(:totalprice)
      
      @last_n_transactions_array << {transno: t.transno, operator: t.operator, time: t.time, transvalue: transvalue.to_f, tender1: t.tender1.to_f, tender2: t.tender2.to_f, change: t.change.to_f, paid: (t.tender1 - t.change).to_f, items: item_array}  
    end
    
    haml :transactions
    
  end

end