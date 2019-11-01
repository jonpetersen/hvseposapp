require 'dbf'
require "active_record"
require "mysql2"
require "yaml"
require "../configs/deploy_setting.rb"
require "../configs/active_record_setting.rb"
#require "./configs/deploy_setting.rb"
#require "./configs/active_record_setting.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Group < ActiveRecord::Base
  self.inheritance_column = nil
end

class Depart < ActiveRecord::Base
  self.inheritance_column = nil
end

class CreateGroups < ActiveRecord::Migration[4.2]
  def self.up
    table = DBF::Table.new($aws_dir + "GROUPS.dbf")
    new_schema = table.schema.gsub!("id","gid")
    new_schema = new_schema.gsub!("cuniquegid","cuniqueid")
    new_schema = new_schema.gsub!("GROUPS","groups")
    eval(new_schema)
    Group.reset_column_information
    table.each do |record|
      Group.create(gid: record.id,  desc: record.desc, cuniqueid: record.cuniqueid, dtlastedit: record.dtlastedit) if record.present?
    end
    add_index :groups, :gid
  end

  def self.down
    drop_table :groups
  end
end

class CreateDeparts < ActiveRecord::Migration[4.2]
  def self.up
    table = DBF::Table.new($aws_dir + "DEPART.dbf")
    new_schema = table.schema.gsub!("id","gid")
    new_schema = new_schema.gsub!("DEPART","departs")
    new_schema = new_schema.gsub!("t.column \"gid\", :string","t.column \"gid\", :int")
    new_schema = new_schema.gsub!("t.column \"group\", :string","t.column \"group\", :int")
    
    eval(new_schema)

    Depart.reset_column_information
    table.each do |record|
      Depart.create(gid: record.id.to_i,  desc: record.desc, group: record.group.to_i, maxdisc: record.maxdisc) if record.present?
    end
    add_index :departs, :gid
  end

  def self.down
    drop_table :departs
  end
end

table = DBF::Table.new($aws_dir + "GROUPS.dbf")
if Group.table_exists?
  #if Group.count != table.count 
    CreateGroups.down
    CreateGroups.up
  #end
else
  CreateGroups.up
end

table = DBF::Table.new($aws_dir + "DEPART.dbf")
if Depart.table_exists?
  #if Depart.count != table.count 
    CreateDeparts.down
    CreateDeparts.up
  #end
else
  CreateDeparts.up
end