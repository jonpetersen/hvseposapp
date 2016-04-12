class CreateStockquantities < ActiveRecord::Migration
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
