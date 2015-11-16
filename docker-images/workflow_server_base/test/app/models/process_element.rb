class ProcessElement < ActiveRecord::Base
  WORKFLOW_ELEMENT_TYPES = %w[ StartElement EndElement OrSplitElement OrJoinElement AndSplitElement AndJoinElement ManualActivity AutomaticActivity ContainerizedActivity ]

  belongs_to :process_definition
  belongs_to :element, polymorphic: true
  has_one :process_element_representation
  before_create :build_process_element_representation
end
