class NestcamController < Sinatra::Base

  get '/' do
    haml :nestcam
  end

end
