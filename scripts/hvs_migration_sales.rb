require 'dbf'
require "active_record"
require "mysql"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

ActiveRecord::Base.establish_connection(  
  :adapter => "mysql",  
  :host => "localhost",  
  :database =>  "hvs",
  :username => "jon",
  :password => "a6bert00") 


class Sale < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class CreateSales < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "Sales.dbf")
    schema = table.schema.gsub!("Sales","sales")
    schema = schema.gsub!("desc","description")
    eval(schema)
    add_column :sales, :created_at, :datetime
    Sale.reset_column_information
    table.each do |record|
      Sale.create(type: record.type, branch: record.branch, terminal: record.terminal, transno: record.transno, operator: record.operator, date: record.date, time: record.time, plu: record.plu, description: record.desc, qty: record.qty, unitqty: record.unitqty, cost: record.cost, vatcode: record.vatcode, vatamount: record.vatamount, unitprice: record.unitprice, totalprice: record.totalprice, refdreason: record.refdreason, discamount: record.discamount, discreason: record.discreason, mixamount: record.mixamount, mixmatch: record.mixmatch, shiftdisc: record.shiftdisc, shifttable: record.shifttable, freetext1: record.freetext1, freetext2: record.freetext2, freetext3: record.freetext3, change: record.change, tender1: record.tender1, tender2: record.tender2, tender3: record.tender3, tender4: record.tender4, tender5: record.tender5, tender6: record.tender6, tender7: record.tender7, tender8: record.tender8, tender9: record.tender9, tender10: record.tender10, tender11: record.tender11, tender12: record.tender12, acccode: record.acccode, accref: record.accref, custcode: record.custcode, caddressid: record.caddressid, loypoints: record.loypoints, charge: record.charge, sheet: record.sheet, condiment1: record.condiment1, condiment2: record.condiment2, condiment3: record.condiment3, remoteprn: record.remoteprn, printed: record.printed, first: record.first, reportdate: record.reportdate, covers: record.covers, serialnum: record.serialnum, q1: record.q1, q2: record.q2, q3: record.q3, qtydes: record.qtydes, pricechg: record.pricechg, cd_no: record.cd_no, lexport: record.lexport, nstdprice: record.nstdprice, istatus: record.istatus, nnsreason: record.nnsreason, luncexport: record.luncexport, ddysldate: record.ddysldate, ncashback: record.ncashback, nrounding: record.nrounding, lprinted: record.lprinted, nvoreason: record.nvoreason, cuov: record.cuov, ctransref: record.ctransref, lshift: record.lshift, nlineno: record.nlineno, ipricelvl: record.ipricelvl, lcompleted: record.lcompleted, nmmqty: record.nmmqty, lflag: record.lflag, cmmatchid: record.cmmatchid, ndeposit: record.ndeposit, lrecipe: record.lrecipe, nseat: record.nseat, ncourse: record.ncourse, ccertno: record.ccertno, lrechead: record.lrechead, cgeneric: record.cgeneric, nplusper: record.nplusper, cuniqueid: record.cuniqueid, norderline: record.norderline, nwidth: record.nwidth, nlength: record.nlength, ctaxcodes: record.ctaxcodes, cdeporef: record.cdeporef, nredmpts: record.nredmpts, lmarkup: record.lmarkup, cukey: record.cukey, ctsuffix: record.ctsuffix, ceodid: record.ceodid, lrecitem: record.lrecitem, ntaxshift: record.ntaxshift, lrefunded: record.lrefunded, loycode: record.loycode, lstkupdtd: record.lstkupdtd, lsageexp: record.lsageexp, cgeneric2: record.cgeneric2, created_at: Time.now) if record
    end
    add_index :sales, :plu
    add_index :sales, :type
    
    change_table :sales do |t|
      t.change :cost, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :vatamount, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :unitprice, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :totalprice, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :discamount, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :mixamount, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :shiftdisc, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :change, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :tender1, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :tender2, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :tender3, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :charge, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :pricechg, :decimal, :precision => 10, :scale => 2, :default => 0.0
    end
  end

  def self.down
    drop_table :sales
  end
end

table = DBF::Table.new($aws_dir + "Sales.dbf")
if Sale.count != table.count
  CreateSales.down if ActiveRecord::Base.connection.table_exists? 'sales'
  CreateSales.up
end
