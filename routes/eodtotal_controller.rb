class EodtotalController < Sinatra::Base

  get '/' do
    value = Eodlog.last.ntxbtotval.to_json
    eod_date = Eodlog.last.dtdatetime.to_json
    value
  end

end