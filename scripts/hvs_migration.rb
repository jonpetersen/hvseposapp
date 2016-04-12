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

class Group < ActiveRecord::Base
  has_many :departs
  has_many :sales, through: :departs
  has_many :stocks, through: :departs
  self.inheritance_column = nil
end

class Depart < ActiveRecord::Base
  #belongs_to :group
  #has_many :sales, through: :stocks
  self.inheritance_column = nil
end

class Stock < ActiveRecord::Base
  #belongs_to :depart
  self.primary_key = "cuniqueid"
  has_many :sales
  has_one :stockquantity
  self.inheritance_column = nil
end

class Stockquantity < ActiveRecord::Base
  belongs_to :stock, foreign_key: "cpluid"
  self.inheritance_column = nil
end

class Sale < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class Eodlog < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class Inward < ActiveRecord::Base
  self.inheritance_column = nil
end

class CreateGroups < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "GROUPS.dbf")
    new_schema = table.schema.gsub!("id","gid")
    new_schema = new_schema.gsub!("GROUPS","groups")
    eval(new_schema)
    Group.reset_column_information
    table.each do |record|
      Group.create(gid: record.id,  desc: record.desc)
    end
    add_index :groups, :gid
  end

  def self.down
    drop_table :groups
  end
end

class CreateDeparts < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "DEPART.dbf")
    new_schema = table.schema.gsub!("id","gid")
    new_schema = new_schema.gsub!("DEPART","departs")
    eval(new_schema)

    Depart.reset_column_information
    table.each do |record|
      Depart.create(gid: record.id,  desc: record.desc, group: record.group, maxdisc: record.maxdisc) if record.present?
    end
    add_index :departs, :gid
  end

  def self.down
    drop_table :departs
  end
end

class CreateSales < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "allsales.DBF")
    new_schema = table.schema.gsub!("allsales","sales")
    eval(new_schema)
    Sale.reset_column_information
    table.each do |record|
      Sale.create(type: record.type, branch: record.branch, terminal: record.terminal, transno: record.transno, operator: record.operator, date: record.date, time: record.time, plu: record.plu, desc: record.desc, qty: record.qty, unitqty: record.unitqty, cost: record.cost, vatcode: record.vatcode, vatamount: record.vatamount, unitprice: record.unitprice, totalprice: record.totalprice, refdreason: record.refdreason, discamount: record.discamount, discreason: record.discreason, mixamount: record.mixamount, mixmatch: record.mixmatch, shiftdisc: record.shiftdisc, shifttable: record.shifttable, freetext1: record.freetext1, freetext2: record.freetext2, freetext3: record.freetext3, change: record.change, tender1: record.tender1, tender2: record.tender2, tender3: record.tender3, tender4: record.tender4, tender5: record.tender5, tender6: record.tender6, tender7: record.tender7, tender8: record.tender8, tender9: record.tender9, tender10: record.tender10, tender11: record.tender11, tender12: record.tender12, acccode: record.acccode, accref: record.accref, custcode: record.custcode, caddressid: record.caddressid, loypoints: record.loypoints, charge: record.charge, sheet: record.sheet, condiment1: record.condiment1, condiment2: record.condiment2, condiment3: record.condiment3, remoteprn: record.remoteprn, printed: record.printed, first: record.first, reportdate: record.reportdate, covers: record.covers, serialnum: record.serialnum, q1: record.q1, q2: record.q2, q3: record.q3, qtydes: record.qtydes, pricechg: record.pricechg, cd_no: record.cd_no, lexport: record.lexport, nstdprice: record.nstdprice, istatus: record.istatus, nnsreason: record.nnsreason, luncexport: record.luncexport, ddysldate: record.ddysldate, ncashback: record.ncashback, nrounding: record.nrounding, lprinted: record.lprinted, nvoreason: record.nvoreason, cuov: record.cuov, ctransref: record.ctransref, lshift: record.lshift, nlineno: record.nlineno, ipricelvl: record.ipricelvl, lcompleted: record.lcompleted, nmmqty: record.nmmqty, lflag: record.lflag, cmmatchid: record.cmmatchid, ndeposit: record.ndeposit, lrecipe: record.lrecipe, nseat: record.nseat, ncourse: record.ncourse, ccertno: record.ccertno, lrechead: record.lrechead, cgeneric: record.cgeneric, nplusper: record.nplusper, cuniqueid: record.cuniqueid, norderline: record.norderline, nwidth: record.nwidth, nlength: record.nlength, ctaxcodes: record.ctaxcodes, cdeporef: record.cdeporef, nredmpts: record.nredmpts, lmarkup: record.lmarkup, cukey: record.cukey, ctsuffix: record.ctsuffix, ceodid: record.ceodid, lrecitem: record.lrecitem, ntaxshift: record.ntaxshift, lrefunded: record.lrefunded, loycode: record.loycode, lstkupdtd: record.lstkupdtd, lsageexp: record.lsageexp, cgeneric2: record.cgeneric2)
    end
    add_index :sales, :plu
    add_index :sales, :type
  end

  def self.down
    drop_table :sales
  end
end

class CreateEodlogs < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "EODLOG.DBF")
    new_schema = table.schema.gsub!("EODLOG","eodlogs")
    eval(new_schema)
    Eodlog.reset_column_information
    table.each do |record|
      Eodlog.create(dtdatetime: record.dtdatetime, coperator: record.coperator, dtlastedit: record.dtlastedit, ntransqty: record.ntransqty, ngsalesqty: record.ngsalesqty, ngsalesval: record.ngsalesval, ndiscqty: record.ndiscqty, ndiscval: record.ndiscval, nmixval: record.nmixval, nrefdqty: record.nrefdqty, nrefdval: record.nrefdval, nnosaleqty: record.nnosaleqty, nviqty: record.nviqty, ntaxtotval: record.ntaxtotval, ntxbtotval: record.ntxbtotval, ntx1_val: record.ntx1_val, ntxbl1_val: record.ntxbl1_val, ntx2_val: record.ntx2_val, ntxbl2_val: record.ntxbl1_val, ntx3_val: record.ntx3_val, ntxbl3_val: record.ntxbl1_val, nvivalue: record.nvivalue)
    end
  end

  def self.down
    drop_table :eodlogs
  end
end

class CreateInwards < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "INWARDS.dbf")
    new_schema = table.schema.gsub!("INWARDS","inwards")
    eval(new_schema)
    Stockquantity.reset_column_information
    table.each do |record|
      Inward.create(branch: record.branch, ref: record.ref, supplier: record.supplier, supp_ref: record.supp_ref, date_in: record.date_in, plu: record.plu, desc: record.desc, case_qty: record.case_qty, case_ord: record.case_ord, case_del: record.case_del, case_out: record.case_out, case_cost: record.case_cost, case_in: record.case_in, completed: record.completed, first: record.first, comment: record.comment, creceived: record.creceived, cuniqueid: record.cuniqueid, ntaxamount: record.ntaxamount, ntaxcode: record.ntaxcode, ltaken: record.ltaken, dtlastedit: record.dtlastedit, nunits_ord: record.nunits_ord, nunits_del: record.nunits_del, nunits_out: record.nunits_out, nunits_in: record.nunits_in, linternal: record.linternal, cordertype: record.cordertype, comments: record.comments)
    end
  end

  def self.down
    drop_table :inwards
  end
end

class CreateStocks < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "Stock.DBF")
    new_schema = table.schema.gsub!("Stock","stocks")
    eval(new_schema)

    Stock.reset_column_information
    table.each do |record|
      Stock.create(plu: record.plu, desc: record.desc, dept: record.dept,  supp: record.supp,  suppcode: record.suppcode,  cost: record.cost,  vatcode: record.vatcode,  vatrate: record.vatrate,  qty1: record.qty1,  price1: record.price1,  qty2: record.qty2,  price2: record.price2,  qty3: record.qty3,  price3: record.price3,  qty4: record.qty4,  price4: record.price4,  qty5: record.qty5,  price5: record.price5,  qty6: record.qty6,  price6: record.price6,  stock: record.stock,  caseqty: record.caseqty,  min: record.min,  max: record.max,  stop: record.stop,  mixmatch: record.mixmatch,  pshift1: record.pshift1,  pshift2: record.pshift2,  pshift3: record.pshift3,  pshift4: record.pshift4,  pshift5: record.pshift5,  pshift6: record.pshift6,  followon: record.followon,  bonus: record.bonus,  kitchen: record.kitchen,  opalert: record.opalert,  prnalert: record.prnalert,  comment1: record.comment1,  comment2: record.comment2,  comment3: record.comment3,  location: record.location,  condiment1: record.condiment1,  condiment2: record.condiment2,  condiment3: record.condiment3,  qtydes1: record.qtydes1,  qtydes2: record.qtydes2,  qtydes3: record.qtydes3,  qtydes4: record.qtydes4,  qtydes5: record.qtydes5,  qtydes6: record.qtydes6,  lastsold: record.lastsold,  lastrece: record.lastrece,  lastorder: record.lastorder,  serialmin: record.serialmin,  serialmax: record.serialmax,  opcomment: record.opcomment,  question1: record.question1,  question2: record.question2,  question3: record.question3,  comprece: record.comprece,  opening: record.opening,  stockin: record.stockin,  stockout: record.stockout,  avgcost: record.avgcost,  lasttake: record.lasttake,  maxdisc: record.maxdisc,  loypoints: record.loypoints,  compstock: record.compstock,  postsale: record.postsale,  takeout: record.takeout,  nonstock: record.nonstock,  custpts: record.custpts,  photo: record.photo,  remtext1: record.remtext1,  remtext2: record.remtext2,  loyex: record.loyex,  redonrem: record.redonrem,  shelf_lab: record.shelf_lab,  prod_lab: record.prod_lab,  sales_qty: record.sales_qty,  casecost: record.casecost,  saleslabel: record.saleslabel,  labelprn: record.labelprn,  cwmgroup: record.cwmgroup,  cwmplu: record.cwmplu,  nuovqty: record.nuovqty,  cuovlabel: record.cuovlabel,  nweight: record.nweight,  lweighable: record.lweighable,  cgroupid: record.cgroupid,  cuniqueid: record.cuniqueid,  nonorder: record.nonorder,  lghost: record.lghost,  nghostsell: record.nghostsell,  nghostmsel: record.nghostmsel,  cmasterplu: record.cmasterplu,  lmodifier: record.lmodifier,  cdefloc: record.cdefloc,  letopup: record.letopup,  lrecipe: record.lrecipe,  lonfly: record.lonfly,  luncexport: record.luncexport,  ltracking: record.ltracking,  ndcstubs: record.ndcstubs,  lrepair: record.lrepair,  nrepmargin: record.nrepmargin,  ldcmeasure: record.ldcmeasure,  nwsfcolour: record.nwsfcolour,  nwsbcolour: record.nwsbcolour,  lwsexclude: record.lwsexclude,  lsageexcl: record.lsageexcl,  nwsseq: record.nwsseq,  lusepict: record.lusepict,  lnontax: record.lnontax,  ltrainee: record.ltrainee,  lnoreturn: record.lnoreturn,  lwsconsol: record.lwsconsol,  lascondi: record.lascondi,  lusedmm: record.lusedmm,  ctheme: record.ctheme,  nrcpremote: record.nrcpremote,  mrcpinst: record.mrcpinst,  lrcpdispla: record.lrcpdispla,  lrcpdtrain: record.lrcpdtrain,  nthfcolour: record.nthfcolour,  lvoucher: record.lvoucher,  lvchaccnt: record.lvchaccnt,  lvchticket: record.lvchticket,  lvchserial: record.lvchserial,  lfreqplu: record.lfreqplu,  ifrequency: record.ifrequency,  ldelivery: record.ldelivery,  ilabwareid: record.ilabwareid,  lpackage: record.lpackage,  nthbcolour: record.nthbcolour,  linsurance: record.linsurance,  nonorderu: record.nonorderu,  leodprint: record.leodprint,  lsquidrdm: record.lsquidrdm,  lsquidtop: record.lsquidtop,  lwghtbcode: record.lwghtbcode,  csize: record.csize,  cfacing: record.cfacing) if record.present?
      #Stock.create(plu: record.plu,  desc: record.desc, dept: record.dept, supp: record.supp, vatcode: record.vatcode, cost: record.cost, vatrate: record.vatrate, qty1: record.qty1, price1: record.price1, stock: record.stock, lastsold: record.lastsold) 
    end
    add_index :stocks, :plu
  end

  def self.down
    drop_table :stocks
  end
end

class CreateStockquantities < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "StockQuantitiesByLocation.DBF")
    new_schema = table.schema.gsub!("StockQuantitiesByLocation","stockquantities")
    eval(new_schema)
    Stockquantity.reset_column_information
    table.each do |record|
      Stockquantity.create(cuniqueid: record.cuniqueid, cpluid: record.cpluid, nstocklvl: record.nstocklvl, dlastsold: record.dlastsold, dlastrecv: record.dlastrecv, nonorder: record.nonorder, dduedate: record.dduedate, clocid: record.clocid, nbranch: record.nbranch, dtlastedit: record.dtlastedit, nonorderu: record.nonorderu)
    end
  end

  def self.down
    drop_table :stockquantities
  end
end

CreateGroups.down
CreateDeparts.down
CreateSales.down
CreateEodlogs.down
CreateInwards.down

CreateGroups.up
CreateDeparts.up
CreateSales.up
CreateEodlogs.up
CreateInwards.up


CreateStocks.down
CreateStockquantities.down

CreateStocks.up
CreateStockquantities.up



#Sale.first
#Group.first
#Depart.first
#Stock.first
#Eodlog.last
#
#opennonvatsales = Sale.where(desc: 'Open Non VAT', type: 'P')
#nonvatsales.size
#Sale.where(date: "2016-03-01", type: "P").sum(:totalprice, :all).to_f
#Sale.where(type: "P").sum(:vatamount, :all).to_f
#Sale.where(date: "2016-03-01", type: "P").sum(:vatamount, :all).to_f
#Sale.where(desc: "Open Non VAT", type: "P").sum(:vatamount).to_f
#
#Sale.where(type: "P").sum("totalprice").to_f
#Eodlog.sum("ntxbtotval").to_f