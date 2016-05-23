class BakeoffsalesreportController < Sinatra::Base

  get '/' do
    
    #90201 sausage roll
    #90205 pies
    #90227 Steak & Kidney Pie
    #90228 Chicken and Mushroom Pie
    #90229 Mince and Onion Pie
    #90203 Slices
    #90225 Slice peppered steak
    #90226 Slice Veg
    #90202 Pasty
    #90221 Pasty Trad
    #90222 Pasty Lamb & Mint
    #90223 Pasty Veg
    #90224 Pasty Cheese and Onion
    
    #90207 croissant
    #90209 pain au raisin
    #90209 pain au choc
    #90210 almond crois
    
    bakeoff_array_savoury = ["90201","90205","90227","90228","90229","90203","90225","90226","90202","90221","90222","90223","90224"]
    
    bakeoff_array_sr_pies= ["90201","90205","90227","90228","90229"]
    bakeoff_array_slices= ["90203","90225","90226"]
    bakeoff_array_pasty= ["90202","90221","90222","90223","90224"]
        
    bakeoff_array_pastry = ["90207","90209","90208","90210"]
    
    @bakeoffallsales_savoury = []
    @bakeoffallsales_sr_pies = []
    @bakeoffallsales_slices = []
    @bakeoffallsales_pasties = []
    @bakeoffallsales_pastry = []
 
    bakeoff_array_sr_pies.each do |item|
      
      item_desc = Stock.where('plu = ?',item).first.desc
      sales = Sale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      allsales = Allsale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      archivesales = Archivesale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
    
      everysale =  archivesales.merge(allsales){|key, oldval, newval| newval + oldval}.merge(sales){|key, oldval, newval| newval + oldval}.sort_by{|k,v| k}
      @bakeoffallsales_sr_pies << {item_desc => everysale}
    end
    
    bakeoff_array_slices.each do |item|
      
      item_desc = Stock.where('plu = ?',item).first.desc
      sales = Sale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      allsales = Allsale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      archivesales = Archivesale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
    
      everysale =  archivesales.merge(allsales){|key, oldval, newval| newval + oldval}.merge(sales){|key, oldval, newval| newval + oldval}.sort_by{|k,v| k}
      @bakeoffallsales_slices << {item_desc => everysale}
    end
    
    bakeoff_array_pasty.each do |item|
      
      item_desc = Stock.where('plu = ?',item).first.desc
      sales = Sale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      allsales = Allsale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      archivesales = Archivesale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
    
      everysale =  archivesales.merge(allsales){|key, oldval, newval| newval + oldval}.merge(sales){|key, oldval, newval| newval + oldval}.sort_by{|k,v| k}
      @bakeoffallsales_pasties << {item_desc => everysale}
    end
        
    bakeoff_array_pastry.each do |item|
      
      item_desc = Stock.where('plu = ?',item).first.desc
      sales = Sale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      allsales = Allsale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
      archivesales = Archivesale.where('plu = ? AND type = ?',item,"P").group_by_day(:created_at, range: Time.parse("28 Oct 2015")..Date.today.end_of_day).sum(:qty)
    
      everysale =  archivesales.merge(allsales){|key, oldval, newval| newval + oldval}.merge(sales){|key, oldval, newval| newval + oldval}.sort_by{|k,v| k}
      @bakeoffallsales_pastry << {item_desc => everysale}
    end
    
    haml :bakeoffsales   
  end

end