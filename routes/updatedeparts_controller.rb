class UpdatedepartsController < Sinatra::Base

  get '/' do
    CreateDeparts.down
    CreateDeparts.up
    "done"
  end

end
