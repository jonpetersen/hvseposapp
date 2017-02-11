class HeatmapsWeekendController < Sinatra::Base

  get '/' do
    haml :heatmaps_weekend
  end

end
