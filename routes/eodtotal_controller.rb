class EodtotalController < Sinatra::Base

  get '/' do
    Eodlog.last.ntxbtotval.to_json
  end

end