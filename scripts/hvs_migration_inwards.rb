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

class Inward < ActiveRecord::Base
  self.inheritance_column = nil
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

CreateInwards.down
CreateInwards.up
