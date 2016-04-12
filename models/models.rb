class Group < ActiveRecord::Base
  has_many :departs
  has_many :sales, through: :departs
  has_many :stocks, through: :departs
  self.inheritance_column = nil
end

class Depart < ActiveRecord::Base
  #belongs_to :group
  #has_many :sales, through: :stocks
  self.inheritance_column = nil
end

class Stock < ActiveRecord::Base
  #belongs_to :depart
  self.primary_key = "cuniqueid"
  has_many :sales
  has_one :stockquantity
  self.inheritance_column = nil
end

class Stockquantity < ActiveRecord::Base
  belongs_to :stock, foreign_key: "cpluid"
  self.inheritance_column = nil
end

class Allsale < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class Sale < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class Eodlog < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class Inward < ActiveRecord::Base
  self.inheritance_column = nil
end

class Archivesale < ActiveRecord::Base
  self.inheritance_column = nil
end

