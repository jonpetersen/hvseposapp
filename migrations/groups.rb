class CreateGroups < ActiveRecord::Migration
  def self.up
    table = DBF::Table.new($aws_dir + "GROUPS.dbf")
    new_schema = table.schema.gsub!("id","gid")
    new_schema = new_schema.gsub!("cuniquegid","cuniqueid")
    new_schema = new_schema.gsub!("GROUPS","groups")
    eval(new_schema)
    Group.reset_column_information
    table.each do |record|
      Group.create(gid: record.id,  desc: record.desc, cuniqueid: record.cuniqueid, dtlastedit: record.dtlastedit)
    end
    add_index :groups, :gid
  end

  def self.down
    drop_table :groups
  end
end