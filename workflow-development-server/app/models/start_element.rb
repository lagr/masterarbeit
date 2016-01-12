class StartActivity < ActiveRecord::Base
  include IsPartOfProcess
  
  has_one :trigger
end
