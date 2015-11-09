class WorkflowElement < ActiveRecord::Base
  WORKFLOW_ELEMENT_TYPES = %w[ StartElement EndElement OrSplitElement OrJoinElement AndSplitElement AndJoinElement ManualActivity AutomaticActivity ContainerizedActivity ]

  belongs_to :workflow_version
  belongs_to :element, polymorphic: true
end
