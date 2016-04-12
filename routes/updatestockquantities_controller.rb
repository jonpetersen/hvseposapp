class UpdatestockquantitiesController < Sinatra::Base

  get '/' do
    CreateStockquantities.down
    CreateStockquantities.up
    "done"
  end

end
