require "dbf"
require "active_record"
require "mysql2"
require "yaml"
require 'net/http'
require_relative "../configs/deploy_setting.rb"
require_relative "../configs/active_record_setting.rb"

require "/home/hvsepos/hvseposapp/configs/deploy_setting.rb"
require "/home/hvsepos/hvseposapp/configs/active_record_setting.rb"


$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

splashmap = '747989998842'
donut = '90114'
sroll = '90230'
vanngin = '735850718095'

class Sale < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

if Sale.table_exists?
  opening_sales_splashmap = Sale.where("plu = #{splashmap}").count
  opening_sales_donut = Sale.where("plu = #{donut}").count
  opening_sales_sroll = Sale.where("plu = #{sroll}").count
  opening_sales_vanngin = Sale.where("plu = #{vanngin}").count
end

class CreateSales < ActiveRecord::Migration[4.2]
  def self.up
    table = DBF::Table.new($aws_dir + "Sales.dbf")
    schema = table.schema.gsub!("Sales","sales")
    schema = schema.gsub!("desc","description")
    eval(schema)
    add_column :sales, :created_at, :datetime
    Sale.reset_column_information
    table.each do |record|
      Sale.create(type: record.type,
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
                  created_at: (record.date.to_datetime + Time.parse(record.time).seconds_since_midnight.seconds)) if record
    end
    add_index :sales, :plu
    add_index :sales, :type
    add_index :sales, :date
    add_index :sales, :time
    add_index :sales, [:plu, :type]
    
    
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

recs = 0
table.each do |record|
  recs = recs + 1 unless record.nil?
end

if Sale.table_exists?
  if Sale.count != recs 
    puts "Sale count is #{Sale.count} rec count is #{recs} so creating"
    CreateSales.down
    CreateSales.up
  else
    puts "Sale count is #{Sale.count} rec count is #{recs} so skipping"
  end
else
  CreateSales.up
end

#if Sale.where("plu = #{splashmap}").count > opening_sales_splashmap
#  url = 'https://graph-eu01-euwest1.api.smartthings.com/api/token/91150eb1-de4d-45a5-bb5a-77129d5c4f8c/smartapps/installations/327bca3d-4522-474f-a2ee-e84439fde8f5/execute/:2ee997cb80c2e163af3312852b50b266:?product=splashmap'
#  uri = URI(url)
#  response = Net::HTTP.get(uri)
#end
#
# if Sale.where("plu = #{donut}").count > opening_sales_donut
#   url = 'https://graph-eu01-euwest1.api.smartthings.com/api/token/91150eb1-de4d-45a5-bb5a-77129d5c4f8c/smartapps/installations/327bca3d-4522-474f-a2ee-e84439fde8f5/execute/:2ee997cb80c2e163af3312852b50b266:?product=donut'  
#   uri = URI(url)
#   response = Net::HTTP.get(uri)
# end
# 
# if Sale.where("plu = #{sroll}").count > opening_sales_sroll
#   url = 'https://graph-eu01-euwest1.api.smartthings.com/api/token/91150eb1-de4d-45a5-bb5a-77129d5c4f8c/smartapps/installations/327bca3d-4522-474f-a2ee-e84439fde8f5/execute/:2ee997cb80c2e163af3312852b50b266:?product=sausage%20roll'  
#   uri = URI(url)
#   response = Net::HTTP.get(uri)
# end
# 
# if Sale.where("plu = #{vanngin}").count > opening_sales_vanngin
#   url = 'https://graph-eu01-euwest1.api.smartthings.com/api/token/91150eb1-de4d-45a5-bb5a-77129d5c4f8c/smartapps/installations/327bca3d-4522-474f-a2ee-e84439fde8f5/execute/:2ee997cb80c2e163af3312852b50b266:?product=vann%20lane%20gin'  
#   uri = URI(url)
#   response = Net::HTTP.get(uri)
# end

