class TransactionsizeController < Sinatra::Base

  get '/' do
	  	      
    eods = Eodlog.all
    
    @overallaveragetransaction = (eods.sum(:ngsalesval)/eods.sum(:ntransqty)).to_f
    
    weeklyitemsqty = eods.group_by_week(:dtdatetime).sum(:ngsalesqty).to_a
    weeklytransactionqty = eods.group_by_week(:dtdatetime).sum(:ntransqty).to_a
    weeklytransactionqvalue = eods.group_by_week(:dtdatetime).sum(:ngsalesval).to_a
    @avgweeklytransactionvalue = []
    for i in (0...weeklytransactionqty.size)
      @avgweeklytransactionvalue << [weeklytransactionqty[i][0],(weeklytransactionqvalue[i][1]/weeklytransactionqty[i][1]).to_f]
    end
    @avgweeklyitems = []
    for i in (0...weeklyitemsqty.size)
      @avgweeklyitems << [weeklyitemsqty[i][0],(weeklyitemsqty[i][1]/weeklytransactionqty[i][1]).to_f]
    end
    
    monthlyitemsqty = eods.group_by_month(:dtdatetime).sum(:ngsalesqty).to_a
    monthlytransactionqty = eods.group_by_month(:dtdatetime).sum(:ntransqty).to_a
    monthlytransactionqvalue = eods.group_by_month(:dtdatetime).sum(:ngsalesval).to_a
    @avgmonthlytransactionvalue = []
    for i in (0...monthlytransactionqty.size)
      @avgmonthlytransactionvalue << [monthlytransactionqty[i][0],(monthlytransactionqvalue[i][1]/monthlytransactionqty[i][1]).to_f]
    end
    @avgmonthlyitems = []
    for i in (0...monthlyitemsqty.size)
      @avgmonthlyitems << [monthlyitemsqty[i][0],(monthlyitemsqty[i][1]/monthlytransactionqty[i][1]).to_f]
    end
    
    dayofweekitemsqty = eods.group_by_day_of_week(:dtdatetime, format: "%a").sum(:ngsalesqty).to_a
    dayofweektransactionqty = eods.group_by_day_of_week(:dtdatetime, format: "%a").sum(:ntransqty).to_a
    dayofweektransactionvalue = eods.group_by_day_of_week(:dtdatetime, format: "%a").sum(:ngsalesval).to_a
    @avgdayofweektransactionvalue = []
    for i in (0...dayofweektransactionqty.size)
      @avgdayofweektransactionvalue << [dayofweektransactionqty[i][0],(dayofweektransactionvalue[i][1]/dayofweektransactionqty[i][1]).to_f]
    end
    @avgdayofweekitems =[]
	for i in (0...dayofweektransactionqty.size)
      @avgdayofweekitems << [dayofweekitemsqty[i][0],(dayofweekitemsqty[i][1]/dayofweektransactionqty[i][1]).to_f]
    end
    
    haml :transactionsize
    
  end

end