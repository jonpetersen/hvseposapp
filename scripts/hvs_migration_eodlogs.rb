require 'dbf'
require "active_record"
require "mysql2"
require "yaml"
require_relative "../configs/deploy_setting.rb"
require_relative "../configs/active_record_setting.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Eodlog < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class CreateEodlogs < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "EODLOG.DBF")
    new_schema = table.schema.gsub!("EODLOG","eodlogs")
    eval(new_schema)
    Eodlog.reset_column_information
    table.each do |record|
      Eodlog.create(cuniqueid: record.cuniqueid, dtdatetime: record.dtdatetime, coperator: record.coperator, lcomplete: record.lcomplete, dtlastedit: record.dtlastedit, ntransqty: record.ntransqty, ngsalesqty: record.ngsalesqty, ngsalesval: record.ngsalesval, ndiscqty: record.ndiscqty, ndiscval: record.ndiscval, nmixval: record.nmixval, nrefdqty: record.nrefdqty, nrefdval: record.nrefdval, nnosaleqty: record.nnosaleqty, nviqty: record.nviqty, ntaxtotval: record.ntaxtotval, ntxbtotval: record.ntxbtotval, ntx1_val: record.ntx1_val, ntxbl1_val: record.ntxbl1_val, ntx2_val: record.ntx2_val, ntxbl2_val: record.ntxbl1_val, ntx3_val: record.ntx3_val, ntxbl3_val: record.ntxbl1_val, nvivalue: record.nvivalue)
    end
  change_table :eodlogs do |t|
    t.change :ngsalesval, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ndiscval, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :nmixval, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :nrefdval, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntaxtotval, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntxbtotval, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntx1_val, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntxbl1_val, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntx2_val, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntxbl2_val, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntx3_val, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :ntxbl3_val, :decimal, :precision => 10, :scale => 2, :default => 0.0
    t.change :nvivalue, :decimal, :precision => 10, :scale => 2, :default => 0.0

  end

  end

  def self.down
    drop_table :eodlogs
  end
end

table = DBF::Table.new($aws_dir + "EODLOG.DBF")
if Eodlog.table_exists?
  if Eodlog.count != table.count
    CreateEodlogs.down
    CreateEodlogs.up
  end
else
  CreateEodlogs.up  
end