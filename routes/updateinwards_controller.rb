class UpdateinwardsController < Sinatra::Base

  get '/' do
    CreateInwards.down
    CreateInwards.up
    "done"
  end

end
