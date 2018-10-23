class MonthlyreportController < Sinatra::Base

  get '/' do
	 
	#default to all month if month param is missing
    
    # @salesmonth = Date.strptime("201604", "%Y%m")
    # month = @salesmonth
    
    
    @salesmonth = "all"
    @periodforreport = "All Sales since Oct 28 2015"
	    
    if params[:yyyymm]
      @salesmonth = Date.strptime(params[:yyyymm], "%Y%m")
      @periodforreport = @salesmonth.strftime("%b %Y")
      @salesmonth = "current" if Date.today.strftime("%Y%m") == params[:yyyymm]
    end
    
    # 2016 is Feb 2016 to Feb 2017
    # 2017 is Feb 2017 to Feb 2018 etc
	if params[:yyyy]
      @salesyear = Date.strptime(params[:yyyy], "%Y").strftime("%Y")
      @periodforreport = @salesyear
      @salesyear = "current" if params[:yyyy] == "2018"
    end
    
    class Monthlysales
      def self.totalvalue(month)
	    if month == "all"
		  Archivesale.where("type = ?","P").sum(:totalprice)  
		elsif month == "current"
		  Allsale.where("type = ?","P").sum(:totalprice)  
		else
	      Archivesale.where("type = ? AND MONTH(date) = ? AND YEAR(date) = ?","P",month.month,month.year).sum(:totalprice)
	    end   
	  end
	end
	
	class Yearlysales
      def self.totalvalue(year)
	    if year == "all"
		  Archivesale.where("type = ?","P").sum(:totalprice)  
		elsif year == "current"
		  Allsale.where("type = ?","P").sum(:totalprice)  
		else
	      start_month = year + "-02-01"
	      end_month = (year.to_i + 1).to_s + "-01-31"
	      Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month).sum(:totalprice)
	    end   
	  end
	end
	
	class Monthlyvat
      def self.totalvat(month)
	    if month == "all"
		  Archivesale.where("type = ?","P").sum(:vatamount)  
		elsif month == "current"
		  Allsale.where("type = ?","P").sum(:vatamount)
		else
	      Archivesale.where("type = ? AND MONTH(date) = ? AND YEAR(date) = ?","P",month.month,month.year).sum(:vatamount)
	    end   
	  end
	end
	
	class Yearlyvat
      def self.totalvat(year)
	    if year == "all"
		  Archivesale.where("type = ?","P").sum(:vatamount)  
		elsif year == "current"
		  Allsale.where("type = ?","P").sum(:vatamount)  
		else
	      start_month = year + "-02-01"
	      end_month = (year.to_i + 1).to_s + "-01-31"
	      Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month).sum(:vatamount)
	    end   
	  end
	end    
        
    class Monthlygroups
	  def self.totalvalue(month)
        if month == "all"
	      salesbygroup = Archivesale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")
        elsif
          month == "current"
          salesbygroup = Allsale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")     
        else
          salesbygroup = Archivesale.joins(:stock =>{:depart => :group}).where("type = ? AND MONTH(date) = ? AND YEAR(date) = ?","P",month.month,month.year).group("departs.group")  
        end
        
        salesbygroupsum = salesbygroup.sum(:totalprice)
        orderedsalesbygroup = salesbygroupsum.sort_by{|_key, value| value}.reverse
	    #salesbygroup.sum(:totalprice){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
	    
	    @salesbygroup_array = []
        orderedsalesbygroup.each do |group|
	      @salesbygroup_array << [Group.all.where(:gid => group[0]).first.desc,group[0],group[1]]
        end
          @salesbygroup_array
      end
    end	
    
    class Yearlygroups
	  def self.totalvalue(year)
        if year == "all"
	      salesbygroup = Archivesale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")
        elsif
          year == "current"
          salesbygroup = Allsale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")     
        else
          start_month = year + "-02-01"
	      end_month = (year.to_i + 1).to_s + "-01-31"
          salesbygroup = Archivesale.joins(:stock =>{:depart => :group}).where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month).group("departs.group")  
        end
        orderedsalesbygroup = salesbygroup.sum(:totalprice){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
	    @salesbygroup_array = []
        orderedsalesbygroup.each do |group|
	      @salesbygroup_array << [Group.all.where(:gid => group[0]).first.desc,group[0],group[1]]
        end
          @salesbygroup_array
      end
    end      
	       
    class Monthlysalesbyday
      def self.totalcount(month)
		if month == "all"
		  monthlysales = Archivesale.where("type = ?","P")
		elsif
          month == "current"
          monthlysales = Allsale.where("type = ?","P")
		else
		  monthlysales = Archivesale.where("type = ? AND MONTH(date) = ? AND YEAR(date) = ?","P",month.month,month.year)
		end
	    monthlysales.group_by_day_of_week(:date, week_start: :mon, format: "%a").count
	  end
	end
	
	class Yearlysalesbyday
      def self.totalcount(year)
		if year == "all"
		  yearlysales = Archivesale.where("type = ?","P")
		elsif
          year == "current"
          yearlysales = Allsale.where("type = ?","P")
		else
		  start_month = year + "-02-01"
	      end_month = (year.to_i + 1).to_s + "-01-31"
		  yearlysales = Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month)
		end
	    yearlysales.group_by_day_of_week(:date, week_start: :mon, format: "%a").count
	  end
	end
	
	class Monthlysalesbyhour
      def self.totalcount(month)
		if month == "all"
		  monthlysales = Archivesale.where("type = ?","P")
		elsif
          month == "current"
          monthlysales = Allsale.where("type = ?","P")
		else
		  monthlysales = Archivesale.where("type = ? AND MONTH(date) = ? AND YEAR(date) = ?","P",month.month,month.year)
		end
		monthlysales.group("hour(time)").count
	  end
	end
	
	class Yearlysalesbyhour
      def self.totalcount(year)
		if year == "all"
		  yearlysales = Archivesale.where("type = ?","P")
		elsif
          year == "current"
          yearlysales = Allsale.where("type = ?","P")
		else
		  start_month = year + "-02-01"
	      end_month = (year.to_i + 1).to_s + "-01-31"
		  yearysales = Archivesale.where("type = ? AND date BETWEEN ? AND ?","P",start_month,end_month)
		end
		yearysales.group("hour(time)").count
	  end
	end

    if params[:yyyymm]
      @sales = Monthlysales.totalvalue(@salesmonth)
      @vat = Monthlyvat.totalvat(@salesmonth)
      @vatpercent = ((@vat/@sales) * 100).round(2)
      @groupsales = Monthlygroups.totalvalue(@salesmonth)
      @salesbydayofweek = Monthlysalesbyday.totalcount(@salesmonth)
      @salesbyhourofday = Monthlysalesbyhour.totalcount(@salesmonth)
    end
    
    if params[:yyyy]
	  @sales = Yearlysales.totalvalue(@salesyear)
      @vat = Yearlyvat.totalvat(@salesyear)
      @vatpercent = ((@vat/@sales) * 100).round(2)
      @groupsales = Yearlygroups.totalvalue(@salesyear)
      @salesbydayofweek = Yearlysalesbyday.totalcount(@salesyear)
      @salesbyhourofday = Yearlysalesbyhour.totalcount(@salesyear)
	end
    
    haml :periodreport   
  end

end