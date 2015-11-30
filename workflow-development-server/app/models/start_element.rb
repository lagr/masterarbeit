class StartElement < ActiveRecord::Base
  include IsPartOfProcess
  
  has_one :trigger
end
