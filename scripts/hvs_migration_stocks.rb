require 'dbf'
require "active_record"
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')
require "mysql2"
require "yaml"
require_relative "../configs/deploy_setting.rb"
require_relative "../configs/active_record_setting.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Stock < ActiveRecord::Base
  #belongs_to :depart
  self.primary_key = "cuniqueid"
  has_many :sales
  has_one :stockquantity
  self.inheritance_column = nil
end

class CreateStocksdata  	
  def self.up
    table = DBF::Table.new($aws_dir + "Stock.DBF")
    new_schema = table.schema.gsub!("Stock","stocks")
    eval(new_schema)
    Stock.reset_column_information
    $stocksdata = []
    table.each do |record|
      $stocksdata << Stock.new(plu: record.plu, desc: record.desc, dept: record.dept,  supp: record.supp,  suppcode: record.suppcode,  cost: record.cost,  vatcode: record.vatcode,  vatrate: record.vatrate,  qty1: record.qty1,  price1: record.price1,  qty2: record.qty2,  price2: record.price2,  qty3: record.qty3,  price3: record.price3,  qty4: record.qty4,  price4: record.price4,  qty5: record.qty5,  price5: record.price5,  qty6: record.qty6,  price6: record.price6,  stock: record.stock,  caseqty: record.caseqty,  min: record.min,  max: record.max,  stop: record.stop,  mixmatch: record.mixmatch,  pshift1: record.pshift1,  pshift2: record.pshift2,  pshift3: record.pshift3,  pshift4: record.pshift4,  pshift5: record.pshift5,  pshift6: record.pshift6,  followon: record.followon,  bonus: record.bonus,  kitchen: record.kitchen,  opalert: record.opalert,  prnalert: record.prnalert,  comment1: record.comment1,  comment2: record.comment2,  comment3: record.comment3,  location: record.location,  condiment1: record.condiment1,  condiment2: record.condiment2,  condiment3: record.condiment3,  qtydes1: record.qtydes1,  qtydes2: record.qtydes2,  qtydes3: record.qtydes3,  qtydes4: record.qtydes4,  qtydes5: record.qtydes5,  qtydes6: record.qtydes6,  lastsold: record.lastsold,  lastrece: record.lastrece,  lastorder: record.lastorder,  serialmin: record.serialmin,  serialmax: record.serialmax,  opcomment: record.opcomment,  question1: record.question1,  question2: record.question2,  question3: record.question3,  comprece: record.comprece,  opening: record.opening,  stockin: record.stockin,  stockout: record.stockout,  avgcost: record.avgcost,  lasttake: record.lasttake,  maxdisc: record.maxdisc,  loypoints: record.loypoints,  compstock: record.compstock,  postsale: record.postsale,  takeout: record.takeout,  nonstock: record.nonstock,  custpts: record.custpts,  photo: record.photo,  remtext1: record.remtext1,  remtext2: record.remtext2,  loyex: record.loyex,  redonrem: record.redonrem,  shelf_lab: record.shelf_lab,  prod_lab: record.prod_lab,  sales_qty: record.sales_qty,  casecost: record.casecost,  saleslabel: record.saleslabel,  labelprn: record.labelprn,  cwmgroup: record.cwmgroup,  cwmplu: record.cwmplu,  nuovqty: record.nuovqty,  cuovlabel: record.cuovlabel,  nweight: record.nweight,  lweighable: record.lweighable,  cgroupid: record.cgroupid,  cuniqueid: record.cuniqueid,  nonorder: record.nonorder,  lghost: record.lghost,  nghostsell: record.nghostsell,  nghostmsel: record.nghostmsel,  cmasterplu: record.cmasterplu,  lmodifier: record.lmodifier,  cdefloc: record.cdefloc,  letopup: record.letopup,  lrecipe: record.lrecipe,  lonfly: record.lonfly,  luncexport: record.luncexport,  ltracking: record.ltracking,  ndcstubs: record.ndcstubs,  lrepair: record.lrepair,  nrepmargin: record.nrepmargin,  ldcmeasure: record.ldcmeasure,  nwsfcolour: record.nwsfcolour,  nwsbcolour: record.nwsbcolour,  lwsexclude: record.lwsexclude,  lsageexcl: record.lsageexcl,  nwsseq: record.nwsseq,  lusepict: record.lusepict,  lnontax: record.lnontax,  ltrainee: record.ltrainee,  lnoreturn: record.lnoreturn,  lwsconsol: record.lwsconsol,  lascondi: record.lascondi,  lusedmm: record.lusedmm,  ctheme: record.ctheme,  nrcpremote: record.nrcpremote,  mrcpinst: record.mrcpinst,  lrcpdispla: record.lrcpdispla,  lrcpdtrain: record.lrcpdtrain,  nthfcolour: record.nthfcolour,  lvoucher: record.lvoucher,  lvchaccnt: record.lvchaccnt,  lvchticket: record.lvchticket,  lvchserial: record.lvchserial,  lfreqplu: record.lfreqplu,  ifrequency: record.ifrequency,  ldelivery: record.ldelivery,  ilabwareid: record.ilabwareid,  lpackage: record.lpackage,  nthbcolour: record.nthbcolour,  linsurance: record.linsurance,  nonorderu: record.nonorderu,  leodprint: record.leodprint,  lsquidrdm: record.lsquidrdm,  lsquidtop: record.lsquidtop,  lwghtbcode: record.lwghtbcode,  csize: record.csize,  cfacing: record.cfacing) if record.present?
    end
  end	  
end	

class CreateStocks < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "Stock.DBF")
    Stock.import $stocksdata    
    change_table :stocks do |t|
      t.change :cost, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :price1, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :price2, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :price3, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :avgcost, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :casecost, :decimal, :precision => 10, :scale => 2, :default => 0.0
    end
    add_index :stocks, :plu
    add_index :stocks, :dept  
  end

  def self.down
    drop_table :stocks
  end
end

table = DBF::Table.new($aws_dir + "Stock.DBF")
if Stock.table_exists?
  if Stock.count != table.count
    CreateStocks.down
    CreateStocksdata.up
    CreateStocks.up
  end
else
  CreateStocksdata.up
  CreateStocks.up
end