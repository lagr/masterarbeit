class OrJoinElement < ActiveRecord::Base
  include HasManyPredecessors
  include HasOneSuccessor
  include IsProcessElement
end
