class MonthlyreportController < Sinatra::Base

  get '/' do
	 
	#default to all month if month param is missing
    
    # @salesmonth = Date.strptime("201604", "%Y%m")
    # month = @salesmonth
    
    
    @salesmonth = "all"
    @salesmonthforreport = "All Sales since Oct 28 2015"
	    
    if params[:yyyymm]
      @salesmonth = Date.strptime(params[:yyyymm], "%Y%m")
      @salesmonthforreport = @salesmonth.strftime("%b %Y")
      @salesmonth = "current" if Date.today.strftime("%Y%m") == params[:yyyymm]
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

    @monthlysales = Monthlysales.totalvalue(@salesmonth)
    @monthlyvat = Monthlyvat.totalvat(@salesmonth)
    @monthlyvatpercent = ((@monthlyvat/@monthlysales) * 100).round(2)
    @monthlygroupsales = Monthlygroups.totalvalue(@salesmonth)
    @monthlysalesbydayofweek = Monthlysalesbyday.totalcount(@salesmonth)
    @monthlysalesbyhourofday = Monthlysalesbyhour.totalcount(@salesmonth)
    
    haml :monthlyreport   
  end

end