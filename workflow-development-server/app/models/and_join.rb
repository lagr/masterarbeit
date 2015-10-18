class AndJoin < ActiveRecord::Base
  include HasManyPredecessors
  include HasOneSuccessor
  include IsWorkflowElement
    
end