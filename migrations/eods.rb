class CreateEodlogs < ActiveRecord::Migration[4.2]
  def self.up
    table = DBF::Table.new($aws_dir + "EODLOG.DBF")
    new_schema = table.schema.gsub!("EODLOG","eodlogs")
    eval(new_schema)
    Eodlog.reset_column_information
    table.each do |record|
      Eodlog.create(dtdatetime: record.dtdatetime, coperator: record.coperator, dtlastedit: record.dtlastedit, ntransqty: record.ntransqty, ngsalesqty: record.ngsalesqty, ngsalesval: record.ngsalesval, ndiscqty: record.ndiscqty, ndiscval: record.ndiscval, nmixval: record.nmixval, nrefdqty: record.nrefdqty, nrefdval: record.nrefdval, nnosaleqty: record.nnosaleqty, nviqty: record.nviqty, ntaxtotval: record.ntaxtotval, ntxbtotval: record.ntxbtotval, ntx1_val: record.ntx1_val, ntxbl1_val: record.ntxbl1_val, ntx2_val: record.ntx2_val, ntxbl2_val: record.ntxbl1_val, ntx3_val: record.ntx3_val, ntxbl3_val: record.ntxbl1_val, nvivalue: record.nvivalue)
    end
  end

  def self.down
    drop_table :eodlogs
  end
end