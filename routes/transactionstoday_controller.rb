class TransactionstodayController < Sinatra::Base

  get '/' do
  	
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
	  else
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