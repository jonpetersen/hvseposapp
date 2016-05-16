class SaleschartController < Sinatra::Base
  #register Sinatra::Twitter::Bootstrap::Assets
  
  get '/' do
    @sales_counts = Allsale.where("type = ?","P").group(:date).count    
    @sales_values = Allsale.where("type = ?","P").group(:date).sum(:totalprice)
    @salesvat_values = Allsale.where("type = ?","P").group(:date).sum(:vatamount)
            
    @sales_counts[Date.parse("2016-05-02")] = 0
    @sales_values[Date.parse("2016-05-02")] = 0
    @salesvat_values[Date.parse("2016-05-02")] = 0
    
    @sales_values_archive = Archivesale.where("type = ?","P").group(:date).sum(:totalprice)
    @salesvat_values_archive = Archivesale.where("type = ?","P").group(:date).sum(:vatamount)
    
    @missing_sales_values = {@sales_values_archive.keys[97] + 1 => 193.68,@sales_values_archive.keys[97] + 2 => 198.19,@sales_values_archive.keys[97] + 3 => 186.54,@sales_values_archive.keys[97] + 4 => 164.89,@sales_values_archive.keys[97] + 5 => 282.38,@sales_values_archive.keys[97] + 6 => 231.92,@sales_values_archive.keys[97] + 7 => 112.84,@sales_values_archive.keys[97] + 8 => 250.99,@sales_values_archive.keys[97] + 9 => 374.36,@sales_values_archive.keys[97] + 10 => 402.48}
    
    missingvatpercent = 0.077
    
    @missing_salesvat_values = {@salesvat_values_archive.keys[97] + 1 => 193.68 * missingvatpercent,@salesvat_values_archive.keys[97] + 2 => 198.19 * missingvatpercent,@salesvat_values_archive.keys[97] + 3 => 186.54 * missingvatpercent,@salesvat_values_archive.keys[97] + 4 => 164.89 * missingvatpercent,@salesvat_values_archive.keys[97] + 5 => 282.38 * missingvatpercent,@salesvat_values_archive.keys[97] + 6 => 231.92 * missingvatpercent,@salesvat_values_archive.keys[97] + 7 => 112.84 * missingvatpercent,@salesvat_values_archive.keys[97] + 8 => 250.99 * missingvatpercent,@salesvat_values_archive.keys[97] + 9 => 374.36 * missingvatpercent,@salesvat_values_archive.keys[97] + 10 => 402.48 * missingvatpercent}
    
    #merge order changed because April 30th data in archive and allsales
    @all_sales_values = @sales_values.merge(@sales_values_archive).merge(@missing_sales_values) 
    @all_salesvat_values = @salesvat_values_archive.merge(@salesvat_values).merge(@missing_salesvat_values) 

    @all_sales_values[Date.parse("2015-12-25")] = 0
    @all_sales_values[Date.parse("2015-12-26")] = 0
    @all_sales_values[Date.parse("2015-12-27")] = 0
    @all_sales_values[Date.parse("2015-12-28")] = 0
    @all_sales_values[Date.parse("2016-01-01")] = 0
    @all_sales_values[Date.parse("2016-05-02")] = 0
    
    @all_salesvat_values[Date.parse("2015-12-25")] = 0
    @all_salesvat_values[Date.parse("2015-12-26")] = 0
    @all_salesvat_values[Date.parse("2015-12-27")] = 0
    @all_salesvat_values[Date.parse("2015-12-28")] = 0
    @all_salesvat_values[Date.parse("2016-01-01")] = 0
    @all_salesvat_values[Date.parse("2016-05-02")] = 0

    @vatpercent_hash = {}

    @all_sales_values.each do |h|
	  salesvat = @all_salesvat_values.detect {|k,v| k==h[0] }[1]
	  if salesvat != 0
	    @vatpercent_hash[h[0]] = ( salesvat.to_f / h[1].to_f ) * 100
	  else
	    @vatpercent_hash[h[0]] = 0
	  end   
	end
    
    #fix fudge for 30 April 2016 - shouldn't be needed once May has been archived
    @vatpercent_hash[Date.parse("2016-04-30")] = 6.89
    
    #sort into date order for charting
    @all_sales_values = @all_sales_values.sort_by{|k,v| k}
    @vatpercent_hash = @vatpercent_hash.sort_by{|k,v| k}
    
    haml :saleschart
    
    
       
  end

end