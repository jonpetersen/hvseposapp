class BeveragesalesreportController < Sinatra::Base

  get '/' do
    
    #91103 Cappucino
    #91102 Americano
    #91110 Tea - Earl Grey
    #91109 Tea for 2
    #91108 Tea for 1
    #91104 Latte
    #91101 Espresso
    #91106 Mocha
    #91105 Flat White
    #91107 Hot Chocolate
    #91111 Herbal Tea
    
    beverage_array = ["91102","91103","91104","91105","91106","91107","91108","91109","91110","91111"]
        
    @beverageallsales = []
     
    beverage_array.each do |item|
      
      item_desc = Stock.where('plu = ?',item).first.desc
      sales = Sale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      allsales = Allsale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      archivesales = Archivesale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
    
      everysale =  archivesales.merge(allsales){|key, oldval, newval| newval + oldval}.merge(sales){|key, oldval, newval| newval + oldval}.sort_by{|k,v| k}
      @beverageallsales << {item_desc => everysale}
    end
    
    haml :beveragesales   
  end

end