# Main initializer to load required libraries
require_relative 'configs/initializer'

# App Router
app = Rack::Builder.new do

  # CMS
  # map "/cms" do
  #   map("/")   {run CmsController.new }
  # end

  map("/docs") {run DocsController.new }
  map("/")     {run MainController.new }
  map("/test") {run TestController.new }
  map("/groups") {run GroupsController.new }
  map("/updategroups") {run UpdategroupsController.new }
  map("/updateeods") {run UpdateeodsController.new }
  map("/updatearchivesales") {run UpdatearchivesalesController.new }
  map("/updatedeparts") {run UpdatedepartsController.new }
  map("/updateinwards") {run UpdateinwardsController.new }
  map("/updateallsales") {run UpdateallsalesController.new }
  map("/updatesales") {run UpdatesalesController.new }
  map("/updatestocks") {run UpdatestocksController.new }
  map("/updatestockquantities") {run UpdatestockquantitiesController.new }

  
end

run app
