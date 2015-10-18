class EndElement < ActiveRecord::Base
  include HasOnePredecessor
  include IsWorkflowElement
end