class AndJoinElement < ActiveRecord::Base
  include HasManyPredecessors
  include HasOneSuccessor
  include IsWorkflowElement
end
