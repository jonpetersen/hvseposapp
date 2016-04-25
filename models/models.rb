class Group < ActiveRecord::Base
  has_many :departs, foreign_key: 'gid'
  self.primary_key = "gid"
  #has_many :sales, through: :departs
  has_many :stocks, through: :departs
  self.inheritance_column = nil
end

class Depart < ActiveRecord::Base
  belongs_to :group, foreign_key: 'group'
  has_many :archivesales, through: :stocks, foreign_key: 'gid'
  has_many :allsales, through: :stocks, foreign_key: 'gid'
  has_many :sales, through: :stocks, foreign_key: 'gid'
  has_many :stocks, foreign_key: 'gid'
  self.primary_key = "gid"
  self.inheritance_column = nil
end

class Stock < ActiveRecord::Base
  belongs_to :depart, foreign_key: 'dept'
  self.primary_key = "plu"
  has_many :archivesales, foreign_key: 'plu'
  has_many :sales, foreign_key: 'plu' 
  has_many :allsales, foreign_key: 'plu'
  has_one :stockquantity
  self.inheritance_column = nil
end

class Archivesale < ActiveRecord::Base
  belongs_to :stock, foreign_key: 'plu'
  self.primary_key = "cuniqueid"
  self.inheritance_column = nil
end

class Stockquantity < ActiveRecord::Base
  belongs_to :stock, foreign_key: "cpluid"
  self.inheritance_column = nil
end

class Allsale < ActiveRecord::Base
  belongs_to :stock, foreign_key: 'plu'
  self.inheritance_column = nil
end

class Sale < ActiveRecord::Base
  belongs_to :stock, foreign_key: 'plu'
  self.inheritance_column = nil
end

class Eodlog < ActiveRecord::Base
  #belongs_to :stock
  self.inheritance_column = nil
end

class Inward < ActiveRecord::Base
  self.inheritance_column = nil
end



