class BarcodePrintController < Sinatra::Base
  
  get '/' do
	  
	#plu = "5199999901100"  
	  
    plu=params[:plu]
    
    @stockitem = Stock.where("plu = ?",plu).first
    if @stockitem
	  price = @stockitem.price1
	  product = @stockitem.desc
    else
	  @stockitem = Stockalt.where("altsku = ?",plu).first
	  price = @stockitem.stock.price1
	  product = @stockitem.stock.desc
	end
    
    price_label = Money.new(price*100).format
    
    plu_no_checkcode = plu[0...-1]
    
    barcode = Barby::EAN13.new(plu_no_checkcode)
    outputter = Barby::PrawnOutputter.new(barcode)
    
    pdf = Prawn::Document.new(:page_size =>"A4", :page_layout => :portrait,
                              :bottom_margin => 25,
                              :top_margin => 10,
                              :left_margin => 10,
                              :right_margin => 0)
    
    rows = 13
    columns = 5
    
    pdf.define_grid(:columns => columns, :rows => rows, :column_gutter => 0, :row_gutter => 0)
    
    i = (0..((rows * columns) - 1)).to_a
    
    i.each do |i|
    
      pos = i % (rows * columns)
      box = pdf.grid(pos / columns, pos % columns)
          
      pdf.draw_text product, :at => [0,805], :size => 10
      
      pdf.bounding_box box.top_left, :width => box.width, :height => box.height do
        outputter.annotate_pdf(pdf, :xdim => 0.8, :height => 28,:x => 10, :y => 10) 
        pdf.draw_text price_label, :at => [40,0], :size => 10
        
      end
    
    end
    
    pdf.render_file "#{plu}.pdf"
    send_file "#{plu}.pdf", :filename => "#{plu}.pdf", :type => 'Application/octet-stream'
    "done".to_s        
  end

end