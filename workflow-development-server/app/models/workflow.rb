class Workflow < ActiveRecord::Base
  WORKFLOW_ELEMENT_TYPES = %w[ StartElement EndElement OrSplit OrJoin AndSplit AndJoin ManualActivity AutomaticActivity ]
  has_many :workflow_versions  
end
