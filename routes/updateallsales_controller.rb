class UpdateallsalesController < Sinatra::Base

  get '/' do
    CreateAllsales.down
    CreateAllsales.up
    "done"
  end

end
