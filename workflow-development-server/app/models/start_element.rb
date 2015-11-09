class StartElement < ActiveRecord::Base
  include HasOneSuccessor
  include IsWorkflowElement
  
  has_one :trigger
end
