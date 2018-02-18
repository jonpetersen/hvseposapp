require 'dbf'
require "active_record"
require "mysql2"
require "yaml"
require "../configs/deploy_setting.rb"
require "../configs/active_record_setting.rb"
#require "./configs/deploy_setting.rb"
#require "./configs/active_record_setting.rb"
#require "./models/models.rb"

$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

class Temperature < ActiveRecord::Base
  self.inheritance_column = nil
end

class CreateTemperatures < ActiveRecord::Migration
  def self.write
    $records.each do |record|
      Temperature.create(taguuid: record[0], timestamp: record[1], temp: record[2])
    end
  end
end

$records = [["bc:6a:29:00:00:ab:3b:07","2017:07:18:09:03:35",23.5]]

CreateTemperatures.write
    