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
  map("/eodtotal") {run EodtotalController.new }
  map("/salestoday") {run SalestodayController.new }
  map("/salelasttime") {run SalelasttimeController.new }
  map("/salesthismonth") {run SalesthismonthController.new }
  map("/salesthismonthavg") {run SalesthismonthavgController.new }
  map("/transactionsrecent") {run TransactionsrecentController.new }
  map("/goodsinrecent") {run GoodsinrecentController.new }
  map("/stockvatreport") {run StockvatreportController.new }
  map("/vattoday") {run VattodayController.new }
  map("/saleschart") {run SaleschartController.new }
  map("/bootstrap") {run BootstrapController.new }
  map("/topsellersallsales") {run TopsellersallsalesController.new }
  map("/topsellersallsalesreport") {run TopsellersallsalesreportController.new }
  map("/topsellersarchivesales") {run TopsellersarchivesalesController.new }
  map("/topsellersarchivesalesreport") {run TopsellersarchivesalesreportController.new }
  map("/topsellerstodaysales") {run TopsellerstodaysalesController.new }
  map("/topsellerstodaysalesreport") {run TopsellerstodaysalesreportController.new }
  map("/deptsalesreport") {run DeptsalesreportController.new }
  map("/groupsalesreport") {run GroupsalesreportController.new }
  map("/dashboard") {run DashboardController.new }
  map("/stockitem") {run StockitemController.new }
  map("/monthlyreport") {run MonthlyreportController.new }

  
end

run app
