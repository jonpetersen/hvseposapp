class TransactionsthismonthController < Sinatra::Base

  get '/' do
  	
  	allsales_lastdate = Allsale.last.date 
  	
	lastn_transactions = Allsale.where("type = ?","P").group(:transno)
	@sales_value = Allsale.where("type = ?","P").sum(:totalprice)
    
    transactions = lastn_transactions.size
    
    @avgtransactionvalue = (@sales_value.to_f / lastn_transactions.to_a.size).to_f.round(2)

	transactionscount = lastn_transactions.count.values
	@avgtransactionitems = (transactionscount.inject{ |sum, el| sum + el }.to_f / transactionscount.size).round(2)
            
    @last_n_transactions_array = []
    
    lastn_transactions.each do |t|
  	  item_array = [] 
  	  items = Allsale.where("transno = ? AND type = ?",t.transno,"P")
      items.each do |i|      
        item_array << [i.description, i.totalprice.to_f, i.qty]
      end
      
      transvalue = items.sum(:totalprice)
      
      @last_n_transactions_array << {transno: t.transno, operator: t.operator, date: t.date, time: t.time, transvalue: transvalue.to_f, tender1: t.tender1.to_f, tender2: t.tender2.to_f, change: t.change.to_f, paid: (t.tender1 - t.change).to_f, items: item_array}  
    end
    
    haml :monthstransactions
    
  end

end