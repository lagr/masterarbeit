class StartElement < ActiveRecord::Base
  include HasOneSuccessor
  include IsProcessElement
  
  has_one :trigger
end
