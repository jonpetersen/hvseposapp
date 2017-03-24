require 'dbf'
require "active_record"
require "mysql2"
require "yaml"
require_relative "../configs/deploy_setting.rb"
require_relative "../configs/active_record_setting.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Stockalt < ActiveRecord::Base
  belongs_to :stock
  self.inheritance_column = nil
end

class CreateStockalts < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "STOCK_ALT.DBF")
    new_schema = table.schema.gsub!("STOCK_ALT","stockalts")
    new_schema = new_schema.gsub!("mastersku","plu")
    eval(new_schema)
    Stockalt.reset_column_information
    table.each do |record|
      Stockalt.create(cuniqueid: record.cuniqueid, plu: record.mastersku, altsku: record.altsku, prilev: record.prilev, nstocklvl: record.nstocklvl)
    end
  end

  def self.down
    drop_table :stockalts
  end
end

table = DBF::Table.new($aws_dir + "STOCK_ALT.DBF")
if Stockalt.table_exists?
  if Stockalt.count != table.count
    CreateStockalts.down
    CreateStockalts.up
  end
else
  CreateStockalts.up  
end