class GroupsalesreportController < Sinatra::Base
  #default to largest Dept http://hvsapp.jonpetersen.co.uk/groupsalesreport
  #get report for a dept http://hvsapp.jonpetersen.co.uk/groupsalesreport?group=9
  
  get '/' do
    
    @salesbygroup = Sale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")
    @allsalesbygroup = Allsale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")
    @archivesalesbygroup = Archivesale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("departs.group")
    
    @everysalebygroupvalue = @salesbygroup.sum(:totalprice).merge(@allsalesbygroup.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(@archivesalesbygroup.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
    
    @salesbygroup_array = []
    @everysalebygroupvalue.each do |group|
	  @salesbygroup_array << [Group.all.where(:gid => group[0]).first.desc,group[0],group[1]]
    end

    #default to largest group if group param is missing
    @group = "all"
    @group = params[:group] if params[:group]
    if @group != "all"
      @thisgroup = Group.where("gid = ?",@group)[0].desc
    else
      @thisgroup = "All Groups"
    end

    class Groupsales
      def self.totalqty(group)
        if group != "all"
          group_archivesales = Archivesale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("archivesales.plu")
          group_allsales = Allsale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("allsales.plu")
          group_sales = Sale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("sales.plu")
          group_everysale = group_sales.sum(:qty).merge(group_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(group_archivesales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }
        else
          group_archivesales = Archivesale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("archivesales.plu")
          group_allsales = Allsale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("allsales.plu")
          group_sales = Sale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("sales.plu")
          group_everysale = group_sales.sum(:qty).merge(group_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(group_archivesales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }  
        end
      end
      def self.totalprice(group)
        if group != "all"
          group_archivesales = Archivesale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("archivesales.plu")
          group_allsales = Allsale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("allsales.plu")
          group_sales = Sale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("sales.plu")
          group_everysale = group_sales.sum(:totalprice).merge(group_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(group_archivesales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
        else
          group_archivesales = Archivesale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("archivesales.plu")
          group_allsales = Allsale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("allsales.plu")
          group_sales = Sale.joins(:stock =>{:depart => :group}).where("type = ?","P").group("sales.plu")
          group_everysale = group_sales.sum(:totalprice).merge(group_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(group_archivesales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
        end
      end
      def self.salesbydate(group)
	    if group != "all"
	      group_sales_values = Allsale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group(:date).sum(:totalprice)
          group_sales_values_archive = Archivesale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group(:date).sum(:totalprice)
          all_sales_values = group_sales_values_archive.merge(group_sales_values)
        else
          group_sales_values = Allsale.joins(:stock =>{:depart => :group}).where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group(:date).sum(:totalprice)
          group_sales_values_archive = Archivesale.joins(:stock =>{:depart => :group}).where("type = ?","P").group(:date).sum(:totalprice)
          all_sales_values = group_sales_values_archive.merge(group_sales_values)
        end    
	  end
    end
    
    groupsales = Groupsales.totalprice(@group)
    groupqtys = Groupsales.totalqty(@group)
    
    @sales_values = Allsale.where("type = ? AND MONTH(created_at) = ?","P",Date.today.month).group(:date).sum(:totalprice)
    @sales_values_archive = Archivesale.where("type = ?","P").group(:date).sum(:totalprice)
    
    @missing_sales_values = {@sales_values_archive.keys[97] + 1 => 193.68,@sales_values_archive.keys[97] + 2 => 198.19,@sales_values_archive.keys[97] + 3 => 186.54,@sales_values_archive.keys[97] + 4 => 164.89,@sales_values_archive.keys[97] + 5 => 282.38,@sales_values_archive.keys[97] + 6 => 231.92,@sales_values_archive.keys[97] + 7 => 112.84,@sales_values_archive.keys[97] + 8 => 250.99,@sales_values_archive.keys[97] + 9 => 374.36,@sales_values_archive.keys[97] + 10 => 402.48}
     
    @all_sales_values = @sales_values_archive.merge(@sales_values).merge(@missing_sales_values)
    
    if @group != "all"
      @groupsalesseries = Groupsales.salesbydate(@group)
    else
      @groupsalesseries = @all_sales_values
    end
    
    @groupsalesseries[Date.parse("2016-05-02")] = 0
    @groupsalesseries[Date.parse("2015-12-25")] = 0
    @groupsalesseries[Date.parse("2015-12-26")] = 0
    @groupsalesseries[Date.parse("2015-12-27")] = 0
    @groupsalesseries[Date.parse("2015-12-28")] = 0
    @groupsalesseries[Date.parse("2016-01-01")] = 0
    
    @allgroupsalestotal = @all_sales_values.values.sum
    
    @groupsales = []
    
    groupsales.each do |item|
	  itemqty = groupqtys.detect {|key, val| key == item[0]}
      itemdesc = Stock.where("plu = ?",item[0]).first.desc
      item_last_sold = Stock.where("plu = ?",item[0]).first.lastsold
      @groupsales << [itemdesc,item[0],item[1],itemqty[1],item_last_sold]
    end
    
    @report_time = "Sales Since Oct 28 2015"
    haml :groupsales   
  end

end