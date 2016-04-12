class UpdategroupsController < Sinatra::Base

  get '/' do
    #CreateGroups.down
    CreateGroups.up
    "done"
  end

end
