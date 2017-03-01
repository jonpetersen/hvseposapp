class TransactionstodayController < Sinatra::Base

  get '/' do
  	
  	allsales_lastdate = Date.parse("1 Jan 2000")
  	allsales_lastdate = Allsale.last.date if Allsale.last
  	
	if params[:n]
  	
  	  n=params[:n].to_i
      
      sales_transactions = Sale.where("type = ?","P").group(:transno).last(n)    

      if sales_transactions.empty? || allsales_lastdate.today?
	    lastn_transactions = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:transno).last(n)
	    @sales_value = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).sum(:totalprice)
	  else
	    @sales_value = Sale.where("type = ?","P").sum(:totalprice)
	    lastn_transactions = sales_transactions  
	  end
      
    else
      sales_transactions = Sale.where("type = ?","P").group(:transno)    
      
      if sales_transactions.empty? || allsales_lastdate.today?
	    lastn_transactions = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).group(:transno)
	    @sales_value = Allsale.where("type = ? AND date = ?","P",allsales_lastdate).sum(:totalprice)
	  else
	    @sales_value = Sale.where("type = ?","P").sum(:totalprice)
	    lastn_transactions = sales_transactions
	  end
	       
    end
    
    transactions = lastn_transactions.size
    
    #@avgtransactionvalue = (@sales_value.to_f / lastn_transactions.size).to_f.round(2)
    @avgtransactionvalue = (@sales_value.to_f / lastn_transactions.to_a.size).to_f.round(2)

	transactionscount = lastn_transactions.count.values
	@avgtransactionitems = (transactionscount.inject{ |sum, el| sum + el }.to_f / transactionscount.size).round(2)
            
    @last_n_transactions_array = []
    
    lastn_transactions.each do |t|
  	  item_array = [] 
  	  if sales_transactions.empty? || allsales_lastdate.today?
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