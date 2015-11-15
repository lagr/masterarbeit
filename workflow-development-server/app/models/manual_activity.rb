class ManualActivity < ActiveRecord::Base
  include HasOnePredecessor
  include HasOneSuccessor
  include IsProcessElement
end
