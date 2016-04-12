class UpdatestocksController < Sinatra::Base

  get '/' do
    CreateStocks.down
    CreateStocks.up
    "done"
  end

end
