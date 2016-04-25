class StockvatreportController < Sinatra::Base

  get '/' do
    @stock_nonvat = Stock.joins(:depart).where("vatcode = ?",2).order("departs.group", "dept","\'desc\'")
    @stock_vat = Stock.joins(:depart).where("vatcode = ?",1).order("departs.group","dept","\'desc\'")
    @stock_vatother = Stock.joins(:depart).where("vatcode != ? AND vatcode != ?",1,2).order("departs.group","dept","\'desc\'")
    
    @stock_vat_count = @stock_nonvat.count + @stock_vat.count + @stock_vatother.count
    
    @stock_all_count = Stock.joins(:depart).order("departs.group","dept","\'desc\'").count
    
    haml :stockvat
    
  end

end

#@stock_nonvat.each do |p|
#	puts p.plu
#	puts p.
#end
#
#item1 = Stock.joins(:depart).where("plu = ?","9990101").order("departs.group", "dept","\'desc\'").first

#item2 = Stock.joins(:depart).where("plu = ?","87248999").order("departs.group", "dept","\'desc\'").first