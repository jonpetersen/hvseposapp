class UpdateeodsController < Sinatra::Base

  get '/' do
    CreateEodlogs.down
    CreateEodlogs.up
    "done"
  end

end
