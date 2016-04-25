class DeptsalesreportController < Sinatra::Base

  get '/:dept' do
    @dept=params[:dept]

    class Deptsales
      def self.totalqty(dept)
        dept_archivesales = Archivesale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("description")
        dept_allsales = Allsale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("description")
        dept_sales = Sale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("description")
        dept_everysale = dept_sales.sum(:qty).merge(dept_allsales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }.merge(dept_archivesales.sum(:qty)){ |k, a_value, b_value| a_value + b_value }
      end
      def self.totalprice(dept)
        dept_archivesales = Archivesale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("description")
        dept_allsales = Allsale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("description")
        dept_sales = Sale.joins(:stock).where("stocks.dept = ? AND type = ?",dept,"P").group("description")
        dept_everysale = dept_sales.sum(:totalprice).merge(dept_allsales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.merge(dept_archivesales.sum(:totalprice)){ |k, a_value, b_value| a_value + b_value }.sort_by{|_key, value| value}.reverse
      end
    end
    
    deptsales = Deptsales.totalprice(@dept)
    deptqtys = Deptsales.totalqty(@dept)
    
    @deptsales = []
    
    deptsales.each do |item|
	  itemqty = deptqtys.detect {|key, val| key == item[0]}
      @deptsales << [item[0],item[1],itemqty[1]]
    end
    
    @report_time = "All Sales"
    haml :deptsales   
  end

end