class NonsellersController < Sinatra::Base
  #default to largest Dept http://hvsapp.jonpetersen.co.uk/deptsalesreport
  #get report for a dept http://hvsapp.jonpetersen.co.uk/deptsalesreport?dept=101
  
  get '/' do
    
    # item = Stock.joins(:depart).where("plu = ?","7613035195950").first
    
    @nonsellers = []
    Stock.all.each do |item|
      #@item = Stock.joins(:depart).where("plu = ?",item.plu).first
      sales = Sale.where("type = ? AND plu = ?","P",item.plu).count
      allsales = Allsale.where("type = ? AND plu = ?","P",item.plu).count
      archivesales = Archivesale.where("type = ? AND plu = ?","P",item.plu).count
      stock = Stockquantity.where("cpluid = ?",item.cuniqueid)
      stocklvl = 0
      stocklvl = stock.first.nstocklvl if stock.size > 0
      
	  if sales + allsales + archivesales == 0
        @nonsellers << [item.desc,item.plu,item.lastrece,stocklvl]
      end
    end
  haml :nonsellers
  end
end