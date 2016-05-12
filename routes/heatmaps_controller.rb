class HeatmapsController < Sinatra::Base

  get '/' do
    haml :heatmaps
  end

end
