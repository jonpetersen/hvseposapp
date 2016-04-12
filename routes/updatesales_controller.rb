class UpdatesalesController < Sinatra::Base

  get '/' do
    CreateSales.down
    CreateSales.up
    "done"
  end

end
