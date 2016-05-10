require 'dbf'
require "active_record"
require "mysql2"
require "yaml"
require_relative "../configs/deploy_setting.rb"
require_relative "../configs/active_record_setting.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Allsale < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class CreateAllsales < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "allsales.DBF")
    new_schema = table.schema.gsub!("desc","description")
    eval(new_schema)
    add_column :allsales, :created_at, :datetime
    add_column :allsales, :lmmcomp, :tinyint
    add_column :allsales, :lmsm, :tinyint
    add_column :allsales, :imovoqty, :int
    Allsale.reset_column_information
    if Allsale.count != table.count 
      table.each do |record|
	    if record && record.date == Date.parse("2016-04-24")
          Allsale.create(type: record.type,
                         branch: record.branch,
                         terminal: record.terminal,
                         transno: record.transno,
                         operator: record.operator,
                         date: "2016-05-05",
                         time: record.time,
                         plu: record.plu,
                         description: record.desc,
                         qty: record.qty,
                         unitqty: record.unitqty,
                         cost: record.cost,
                         vatcode: record.vatcode,
                         vatamount: record.vatamount,
                         unitprice: record.unitprice,
                         totalprice: record.totalprice,
                         refdreason: record.refdreason,
                         discamount: record.discamount,
                         discreason: record.discreason,
                         mixamount: record.mixamount,
                         mixmatch: record.mixmatch,
                         shiftdisc: record.shiftdisc,
                         shifttable: record.shifttable,
                         freetext1: record.freetext1,
                         freetext2: record.freetext2,
                         freetext3: record.freetext3,
                         change: record.change,
                         tender1: record.tender1,
                         tender2: record.tender2,
                         tender3: record.tender3,
                         tender4: record.tender4,
                         tender5: record.tender5,
                         tender6: record.tender6,
                         tender7: record.tender7,
                         tender8: record.tender8,
                         tender9: record.tender9,
                         tender10: record.tender10,
                         tender11: record.tender11,
                         tender12: record.tender12,
                         acccode: record.acccode,
                         accref: record.accref,
                         custcode: record.custcode,
                         caddressid: record.caddressid,
                         loypoints: record.loypoints,
                         charge: record.charge,
                         sheet: record.sheet,
                         condiment1: record.condiment1,
                         condiment2: record.condiment2,
                         condiment3: record.condiment3,
                         remoteprn: record.remoteprn,
                         printed: record.printed,
                         first: record.first,
                         reportdate: record.reportdate,
                         covers: record.covers,
                         serialnum: record.serialnum,
                         q1: record.q1,
                         q2: record.q2,
                         q3: record.q3,
                         qtydes: record.qtydes,
                         pricechg: record.pricechg,
                         cd_no: record.cd_no,
                         lexport: record.lexport,
                         nstdprice: record.nstdprice,
                         istatus: record.istatus,
                         nnsreason: record.nnsreason,
                         luncexport: record.luncexport,
                         ddysldate: record.ddysldate,
                         ncashback: record.ncashback,
                         nrounding: record.nrounding,
                         lprinted: record.lprinted,
                         nvoreason: record.nvoreason,
                         cuov: record.cuov,
                         ctransref: record.ctransref,
                         lshift: record.lshift,
                         nlineno: record.nlineno,
                         ipricelvl: record.ipricelvl,
                         lcompleted: record.lcompleted,
                         nmmqty: record.nmmqty,
                         lflag: record.lflag,
                         cmmatchid: record.cmmatchid,
                         ndeposit: record.ndeposit,
                         lrecipe: record.lrecipe,
                         nseat: record.nseat,
                         ncourse: record.ncourse,
                         ccertno: record.ccertno,
                         lrechead: record.lrechead,
                         cgeneric: record.cgeneric,
                         nplusper: record.nplusper,
                         cuniqueid: record.cuniqueid,
                         norderline: record.norderline,
                         nwidth: record.nwidth,
                         nlength: record.nlength,
                         ctaxcodes: record.ctaxcodes,
                         cdeporef: record.cdeporef,
                         nredmpts: record.nredmpts,
                         lmarkup: record.lmarkup,
                         cukey: record.cukey,
                         ctsuffix: record.ctsuffix,
                         ceodid: record.ceodid,
                         lrecitem: record.lrecitem,
                         ntaxshift: record.ntaxshift,
                         lrefunded: record.lrefunded,
                         loycode: record.loycode,
                         lstkupdtd: record.lstkupdtd,
                         lsageexp: record.lsageexp,
                         cgeneric2: record.cgeneric2,
                         created_at: Time.now)
      else
        Allsale.create(type: record.type,
                       branch: record.branch,
                       terminal: record.terminal,
                       transno: record.transno,
                       operator: record.operator,
                       date: record.date,
                       time: record.time,
                       plu: record.plu,
                       description: record.desc,
                       qty: record.qty,
                       unitqty: record.unitqty,
                       cost: record.cost,
                       vatcode: record.vatcode,
                       vatamount: record.vatamount,
                       unitprice: record.unitprice,
                       totalprice: record.totalprice,
                       refdreason: record.refdreason,
                       discamount: record.discamount,
                       discreason: record.discreason,
                       mixamount: record.mixamount,
                       mixmatch: record.mixmatch,
                       shiftdisc: record.shiftdisc,
                       shifttable: record.shifttable,
                       freetext1: record.freetext1,
                       freetext2: record.freetext2,
                       freetext3: record.freetext3,
                       change: record.change,
                       tender1: record.tender1,
                       tender2: record.tender2,
                       tender3: record.tender3,
                       tender4: record.tender4,
                       tender5: record.tender5,
                       tender6: record.tender6,
                       tender7: record.tender7,
                       tender8: record.tender8,
                       tender9: record.tender9,
                       tender10: record.tender10,
                       tender11: record.tender11,
                       tender12: record.tender12,
                       acccode: record.acccode,
                       accref: record.accref,
                       custcode: record.custcode,
                       caddressid: record.caddressid,
                       loypoints: record.loypoints,
                       charge: record.charge,
                       sheet: record.sheet,
                       condiment1: record.condiment1,
                       condiment2: record.condiment2,
                       condiment3: record.condiment3,
                       remoteprn: record.remoteprn,
                       printed: record.printed,
                       first: record.first,
                       reportdate: record.reportdate,
                       covers: record.covers,
                       serialnum: record.serialnum,
                       q1: record.q1,
                       q2: record.q2,
                       q3: record.q3,
                       qtydes: record.qtydes,
                       pricechg: record.pricechg,
                       cd_no: record.cd_no,
                       lexport: record.lexport,
                       nstdprice: record.nstdprice,
                       istatus: record.istatus,
                       nnsreason: record.nnsreason,
                       luncexport: record.luncexport,
                       ddysldate: record.ddysldate,
                       ncashback: record.ncashback,
                       nrounding: record.nrounding,
                       lprinted: record.lprinted,
                       nvoreason: record.nvoreason,
                       cuov: record.cuov,
                       ctransref: record.ctransref,
                       lshift: record.lshift,
                       nlineno: record.nlineno,
                       ipricelvl: record.ipricelvl,
                       lcompleted: record.lcompleted,
                       nmmqty: record.nmmqty,
                       lflag: record.lflag,
                       cmmatchid: record.cmmatchid,
                       ndeposit: record.ndeposit,
                       lrecipe: record.lrecipe,
                       nseat: record.nseat,
                       ncourse: record.ncourse,
                       ccertno: record.ccertno,
                       lrechead: record.lrechead,
                       cgeneric: record.cgeneric,
                       nplusper: record.nplusper,
                       cuniqueid: record.cuniqueid,
                       norderline: record.norderline,
                       nwidth: record.nwidth,
                       nlength: record.nlength,
                       ctaxcodes: record.ctaxcodes,
                       cdeporef: record.cdeporef,
                       nredmpts: record.nredmpts,
                       lmarkup: record.lmarkup,
                       cukey: record.cukey,
                       ctsuffix: record.ctsuffix,
                       ceodid: record.ceodid,
                       lrecitem: record.lrecitem,
                       ntaxshift: record.ntaxshift,
                       lrefunded: record.lrefunded,
                       loycode: record.loycode,
                       lstkupdtd: record.lstkupdtd,
                       lsageexp: record.lsageexp,
                       cgeneric2: record.cgeneric2,
                       created_at: Time.now)  
      end
      end
    end
    add_index :allsales, :plu
    add_index :allsales, :type
    add_index :allsales, :date
    add_index :allsales, :description
    add_index :allsales, [:plu, :type]

    change_table :allsales do |t|
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
    drop_table :allsales
  end
end

table = DBF::Table.new($aws_dir + "allsales.DBF")
if Allsale.table_exists?
  if Allsale.count != table.count
    CreateAllsales.down
    CreateAllsales.up
  end
else
  CreateAllsales.up  
end
