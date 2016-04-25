class GroupsalesreportController < Sinatra::Base

  get '/:group' do
    @group=params[:group]

    class Groupsales
      def self.totalqty(group)
        group_archivesales = Archivesale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("description")
        group_allsales = Allsale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("description")
        group_sales = Sale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("description")
        group_everysale = group_sales.sum(:qty).merge(group_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(group_archivesales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }
      end
      def self.totalprice(group)
        group_archivesales = Archivesale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("description")
        group_allsales = Allsale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("description")
        group_sales = Sale.joins(:stock =>{:depart => :group}).where("departs.group = ? AND type = ?",group,"P").group("description")
        group_everysale = group_sales.sum(:totalprice).merge(group_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(group_archivesales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
      end
    end
    
    groupsales = Groupsales.totalprice(@group)
    groupqtys = Groupsales.totalqty(@group)
    
    @groupsales = []
    
    groupsales.each do |item|
	  itemqty = groupqtys.detect {|key, val| key == item[0]}
      @groupsales << [item[0],item[1],itemqty[1]]
    end
    
    @report_time = "All Sales"
    haml :groupsales   
  end

end