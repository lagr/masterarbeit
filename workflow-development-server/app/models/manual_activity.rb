class ManualActivity < ActiveRecord::Base
  include IsPartOfProcess
  include IsAssignable
end
