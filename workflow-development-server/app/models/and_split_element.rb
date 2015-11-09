class AndSplitElement < ActiveRecord::Base
  include HasOnePredecessor
  include HasManySuccessors
  include IsWorkflowElement
end
