class GroupsController < Sinatra::Base

  get '/' do
    groups = Group.all
    #groups.to_json
    groups_array=[]
    groups.each do |group|
	  groups_array << group.desc    
	end
	groups_array.to_json
  end

end
