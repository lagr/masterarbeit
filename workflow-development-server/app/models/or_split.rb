class OrSplit < ActiveRecord::Base
  include HasOnePredecessor
  include HasManySuccessors
  include IsWorkflowElement
end