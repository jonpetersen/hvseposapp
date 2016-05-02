class DashboardController < Sinatra::Base

  get '/' do
    
    haml :dashboard
           
  end

end