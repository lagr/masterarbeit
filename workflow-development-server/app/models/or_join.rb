class OrJoin < ActiveRecord::Base
  include HasManyPredecessors
  include HasOneSuccessor
  include IsWorkflowElement
end