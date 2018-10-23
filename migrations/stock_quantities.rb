require 'dbf'
require "active_record"
require "mysql2"
require "yaml"
require_relative "../configs/deploy_setting.rb"
require_relative "../configs/active_record_setting.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Stockquantity < ActiveRecord::Base
  self.inheritance_column = nil
end

class CreateStockquantities < ActiveRecord::Migration[4.2]
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

table = DBF::Table.new($aws_dir + "StockQuantitiesByLocation.DBF")
if Stockquantity.table_exists?
  if Stockquantity.count != table.count
    CreateStockquantities.down
    CreateStockquantities.up
  end
else
  CreateStockquantities.up
end
