# base
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/advanced_routes'

# gems
require 'logger'
require 'json'
require 'haml'
require 'digest'
require 'date'
require 'time'
require 'yaml'
require 'mysql2'
require 'active_record'
require 'active_record_union'
require 'dbf'
require 'chartkick'
require 'sinatra/twitter-bootstrap'
require 'rails_erd/diagram/graphviz'
require 'money'
require 'groupdate'
require 'bullet'
require 'apriori'


# configs
require_relative 'deploy_setting'
require_relative 'active_record_setting'

$root_path = File.join(File.dirname(__FILE__), '..')
$aws_dir = "/home/hvsepos/Touch/DATA/"
$aws_archivedir = "/home/hvsepos/Touch/ARCHIVE/"

['helpers', 'extlibs', 'models', 'routes', 'migrations'].each do |dir_name|
  dir_path = File.join($root_path, dir_name, '*.rb')
  Dir.glob(dir_path).each do |file|
    require file
  end
end

Groupdate.time_zone = "UTC"
Money.default_currency = Money::Currency.new("GBP")

#RailsERD.options.filetype = :dot
#RailsERD::Diagram::Graphviz.create

class Sinatra::Base
  # helpers
  include DebugOn
  register Sinatra::Twitter::Bootstrap::Assets
  register Sinatra::AdvancedRoutes
  
  # set sinatra's variables
  set :app_name, "Hvseposapp" 
  set :app_logger, Logger.new(File.join($root_path, 'log', "hvseposapp.log"), 'daily')
  set :root, $root_path
  set :environment, DeploySetting.environment

  if settings.environment == :production
    enable  :sessions, :logging, :dump_errors
    disable :run, :reload, :show_exceptions
    # set :redis, Redis.new(:db => 2)
  else
    enable  :sessions, :logging, :dump_errors, :show_exceptions, :reload
    disable :run
    # set :redis, Redis.new(:db => 15)
  end
  
  configure :development do
    Bullet.enable = true
    Bullet.bullet_logger = true
    use Bullet::Rack
  end

end


