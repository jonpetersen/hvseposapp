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