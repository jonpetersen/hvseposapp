class SaleschartController < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets
  
  get '/' do
    @sales_counts = Allsale.where("type = ?","P").group(:date).count
    @sales_values = Allsale.where("type = ?","P").group(:date).sum(:totalprice)
    @sales_values_archive = Archivesale.where("type = ?","P").group(:date).sum(:totalprice)
    
    @missing_sales_values = {@sales_values_archive.keys[97] + 1 => 193.68,@sales_values_archive.keys[97] + 2 => 198.19,@sales_values_archive.keys[97] + 3 => 186.54,@sales_values_archive.keys[97] + 4 => 164.89,@sales_values_archive.keys[97] + 5 => 282.38,@sales_values_archive.keys[97] + 6 => 231.92,@sales_values_archive.keys[97] + 7 => 112.84,@sales_values_archive.keys[97] + 8 => 250.99,@sales_values_archive.keys[97] + 9 => 374.36,@sales_values_archive.keys[97] + 10 => 402.48}
     
    @all_sales_values = @sales_values_archive.merge(@sales_values).merge(@missing_sales_values) 
        
    haml :saleschart
    
    
       
  end

end