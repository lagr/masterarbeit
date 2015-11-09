class ContainerizedActivity < ActiveRecord::Base
  include HasOnePredecessor
  include HasOneSuccessor
  include IsWorkflowElement
end
