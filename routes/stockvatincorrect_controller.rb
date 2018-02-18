class StockvatincorrectController < Sinatra::Base

  get '/' do
    
    vatgroups = [2,3,5,6,11,12,13,15]
    nonvatgroups = [1,8,14]
    mixedvatgroups = [4,7,9,10]
    
    vatdepts_4 = [409,503,504,808,412,413]
    nonvatdepts_4 = [401,403,404,405,406,407,1101,410,411,415,666]
    mixedvatdepts_4 = [402,1103,906]
    
    vatdepts_7 = [502,701]
	nonvatdepts_7 = [414,417,702]
    mixedvatdepts_7 = [] 
    
    vatdepts_9 = [903,911]
	nonvatdepts_9 = [901,902,904]
    mixedvatdepts_9 = [907]
    
    mixedvatdepts_10 = [1102,1104]  
    
    #stock items that have vatcode 2 (0%)  and are in vatable departments
    #get the departments that are in vat groups
    vatgroups_depts = []    
    
    Depart.where(group: vatgroups).each do |dept|
      vatgroups_depts << dept.gid
    end 
    
    #now add in vat depts from mixed vat groups
    vatgroups_depts = vatgroups_depts + vatdepts_4 + vatdepts_7 + vatdepts_9
        
    @stock_nonvat_in_vatdepts = Stock.joins(:depart).where("vatcode = ? AND dept IN (?)",2,vatgroups_depts).order("departs.group", "dept","\'desc\'")
    
    #stock items that have vatcode 1 (20%) or 3 (5%)  and are in vatable departments
    #get the departments that are in nonvat groups
    nonvatgroups_depts = []    
    
    Depart.where(group: nonvatgroups).each do |dept|
      nonvatgroups_depts << dept.gid
    end 
    
    #now add in vat depts from mixed vat groups
    nonvatgroups_depts = nonvatgroups_depts + nonvatdepts_4 + nonvatdepts_7 + nonvatdepts_9
    
    @stock_vat_in_nonvatdepts = Stock.joins(:depart).where("(vatcode = ? OR vatcode = ?) AND dept IN (?)",1,3,nonvatgroups_depts).order("departs.group", "dept","\'desc\'")
    
    #stock items that are in mixed vat depts
    #stock items that are in mixed vatable departments
    mixedvat_depts = mixedvatdepts_4 + mixedvatdepts_7 + mixedvatdepts_9 + mixedvatdepts_10

    @stock_in_mixedvatdepts = Stock.joins(:depart).where("(vatcode = ? OR vatcode = ?) AND dept IN (?)",1,3,mixedvat_depts).order("departs.group", "dept","\'desc\'")

    
    #@stock_nonvat = Stock.joins(:depart).where("vatcode = ?",2).order("departs.group", "dept","\'desc\'")
    #@stock_vat = Stock.joins(:depart).where("vatcode = ?",1).order("departs.group","dept","\'desc\'")
    #@stock_vatother = Stock.joins(:depart).where("vatcode != ? AND vatcode != ?",1,2).order("departs.group","dept","\'desc\'")
    #
    #@stock_vat_count = @stock_nonvat.count + @stock_vat.count + @stock_vatother.count
    #
    #@stock_all_count = Stock.joins(:depart).order("departs.group","dept","\'desc\'").count
    
    haml :stockvatincorrect
    
  end

end

#@stock_nonvat.each do |p|
#	puts p.plu
#	puts p.
#end
#
#item1 = Stock.joins(:depart).where("plu = ?","9990101").order("departs.group", "dept","\'desc\'").first

#item2 = Stock.joins(:depart).where("plu = ?","87248999").order("departs.group", "dept","\'desc\'").first