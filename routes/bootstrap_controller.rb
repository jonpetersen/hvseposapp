class BootstrapController < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  get '/' do
    
    haml :bootstrap
           
  end

end