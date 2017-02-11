class DeptsalesreportController < Sinatra::Base
  #default to largest Dept http://hvsapp.jonpetersen.co.uk/deptsalesreport
  #get report for a dept http://hvsapp.jonpetersen.co.uk/deptsalesreport?dept=101
  
  get '/' do
    
    @salesbydept = Sale.joins(:stock).where("type = ?","P").group("stocks.dept")
    @allsalesbydept = Allsale.joins(:stock).where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group("stocks.dept")
    @archivesalesbydept = Archivesale.joins(:stock).where("type = ?","P").group("stocks.dept")
            
    @everysalebydeptvalue = @salesbydept.sum(:totalprice).merge(@allsalesbydept.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(@archivesalesbydept.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
    #
    @salesbydept_array = []
    @everysalebydeptvalue.each do |dept|
	  puts dept[0]
	  @salesbydept_array << [Depart.all.where(:gid => dept[0]).first.desc,dept[0],dept[1]]
    end
    
    #default to largest dept if dept param is missing
    @dept = "all"
    @dept = params[:dept] if params[:dept]
    if @dept != "all"
      @thisdepart = Depart.where("gid = ?",@dept)[0].desc
    else
      @thisdepart = "All Departments"
    end
    
    class Deptsales
      def self.totalqty(dept)
        if dept != "all" 
          dept_archivesales = Archivesale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("archivesales.plu")
          dept_allsales = Allsale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("allsales.plu")
          dept_sales = Sale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("sales.plu")
          dept_everysale = dept_sales.sum(:qty).merge(dept_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(dept_archivesales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }
        else
          dept_archivesales = Archivesale.joins(:stock).where("type = ?","P").group("archivesales.plu")
          dept_allsales = Allsale.joins(:stock).where("type = ?","P").group("allsales.plu")
          dept_sales = Sale.joins(:stock).where("type = ?","P").group("sales.plu")
          dept_everysale = dept_sales.sum(:qty).merge(dept_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(dept_archivesales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }
        end
      end
      def self.totalprice(dept)
        if dept != "all"
          dept_archivesales = Archivesale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("archivesales.plu")
          dept_allsales = Allsale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("allsales.plu")
          dept_sales = Sale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("sales.plu")
          dept_everysale = dept_sales.sum(:totalprice).merge(dept_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(dept_archivesales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
        else
          dept_archivesales = Archivesale.joins(:stock).where("type = ?","P").group("archivesales.plu")
          dept_allsales = Allsale.joins(:stock).where("type = ?","P").group("allsales.plu")
          dept_sales = Sale.joins(:stock).where("type = ?","P").group("sales.plu")
          dept_everysale = dept_sales.sum(:totalprice).merge(dept_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(dept_archivesales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse        
        end
      end
      def self.salesbydate(dept)
	    if dept != "all"
	      dept_sales_values = Allsale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group(:date).sum(:totalprice)
          dept_sales_values_archive = Archivesale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group(:date).sum(:totalprice)
          all_sales_values = dept_sales_values_archive.merge(dept_sales_values)
        else
          dept_sales_values = Allsale.joins(:stock).where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group(:date).sum(:totalprice)
          dept_sales_values_archive = Archivesale.joins(:stock).where("type = ?","P").group(:date).sum(:totalprice)
          all_sales_values = dept_sales_values_archive.merge(dept_sales_values)
        end    
	  end
	  def self.salesbymonth(dept)
	    if dept != "all"
	      dept_sales_values = Allsale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group_by_month(:created_at).sum(:totalprice)
          dept_sales_values_archive = Archivesale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group_by_month(:created_at).sum(:totalprice)
          all_sales_values = dept_sales_values_archive.merge(dept_sales_values)
        else
          dept_sales_values = Allsale.joins(:stock).where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group_by_month(:created_at).sum(:totalprice)
          dept_sales_values_archive = Archivesale.joins(:stock).where("type = ?","P").group_by_month(:created_at).sum(:totalprice)
          all_sales_values = dept_sales_values_archive.merge(dept_sales_values)
        end    
	  end
    end
    
    deptsales = Deptsales.totalprice(@dept)
    deptqtys = Deptsales.totalqty(@dept)
     
    
    @sales_values = Allsale.where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group(:date).sum(:totalprice)
    @sales_values_archive = Archivesale.where("type = ?","P").group(:date).sum(:totalprice)
    
    @sales_values_monthly = Allsale.where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group_by_month(:created_at).sum(:totalprice)
    @sales_values_archive_monthly = Archivesale.where("type = ?","P").group_by_month(:created_at).sum(:totalprice)
    
    @missing_sales_values = {@sales_values_archive.keys[97] + 1 => 193.68,@sales_values_archive.keys[97] + 2 => 198.19,@sales_values_archive.keys[97] + 3 => 186.54,@sales_values_archive.keys[97] + 4 => 164.89,@sales_values_archive.keys[97] + 5 => 282.38,@sales_values_archive.keys[97] + 6 => 231.92,@sales_values_archive.keys[97] + 7 => 112.84,@sales_values_archive.keys[97] + 8 => 250.99,@sales_values_archive.keys[97] + 9 => 374.36,@sales_values_archive.keys[97] + 10 => 402.48}
     
    @all_sales_values = @sales_values_archive.merge(@sales_values).merge(@missing_sales_values)
    @all_sales_values_monthly = @sales_values_archive_monthly.merge(@sales_values_monthly)
        
    if @dept != "all"
      @deptsalesseries = Deptsales.salesbydate(@dept)
      @deptsalesseries_monthly = Deptsales.salesbymonth(@dept)
    else
      @deptsalesseries = @all_sales_values
      @deptsalesseries_monthly = @all_sales_values_monthly 
    end
    
    @deptsalesseries[Date.parse("2016-05-02")] = 0
    @deptsalesseries[Date.parse("2015-12-25")] = 0
    @deptsalesseries[Date.parse("2015-12-26")] = 0
    @deptsalesseries[Date.parse("2015-12-27")] = 0
    @deptsalesseries[Date.parse("2015-12-28")] = 0
    @deptsalesseries[Date.parse("2016-01-01")] = 0
    
    @alldeptsalestotal = @all_sales_values.values.sum
    
    @deptsales = []
    
    deptsales.each do |item|
	  itemqty = deptqtys.detect {|key, val| key == item[0]}
	  itemdesc = Stock.where("plu = ?",item[0]).first.desc
      item_last_sold = Stock.where("plu = ?",item[0]).first.lastsold
      item_sales_today = Sale.where("plu = ? AND type = ? AND totalprice > ?",item[0],"P",0).sum(:qty)
      item_sales_this_month = Allsale.where("plu = ? AND type = ? AND totalprice > ?",item[0],"P",0).sum(:qty) + item_sales_today
      item_avg_sales_perday_this_month = (item_sales_this_month / Date.today.day).round(2)
      item_wasted_this_month = Allsale.where("plu = ? AND type = ? AND totalprice = ?",item[0],"P",0).sum(:qty)
      @deptsales << [itemdesc,item[0],item[1],itemqty[1],item_last_sold,item_sales_today,item_sales_this_month,item_avg_sales_perday_this_month,item_wasted_this_month]
    end
    
    @report_time = "Sales Since Oct 28 2015"
    haml :deptsales   
  end

end