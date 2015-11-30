class ProcessElement < ActiveRecord::Base
  PROCESS_ELEMENT_TYPES         = %w[StartElement EndElement OrSplitElement OrJoinElement AndSplitElement AndJoinElement ManualActivity AutomaticActivity ContainerizedActivity]
  ELEMENTS_WITH_ONE_SUCCESSOR   = [StartElement, AndJoinElement, OrJoinElement, ManualActivity, AutomaticActivity, ContainerizedActivity]
  ELEMENTS_WITHOUT_SUCCESSOR    = [EndElement]
  ELEMENTS_WITH_ONE_PREDECESSOR = [EndElement, ManualActivity, AutomaticActivity, ContainerizedActivity]
  ELEMENTS_WITHOUT_PREDECESSOR  = [StartElement]

  belongs_to :process_definition
  belongs_to :element, polymorphic: true
  has_one :process_element_representation, dependent: :destroy
  before_create :build_process_element_representation
  
  include HasManyPredecessors
  include HasManySuccessors

  validates_length_of :incoming_control_flows, maximum: 1, if: ->{ element.class.in? ProcessElement::ELEMENTS_WITH_ONE_PREDECESSOR }
  validates_length_of :outgoing_control_flows, maximum: 1, if: ->{ element.class.in? ProcessElement::ELEMENTS_WITH_ONE_SUCCESSOR   }
  validates_length_of :incoming_control_flows, is: 0,      if: ->{ element.class.in? ProcessElement::ELEMENTS_WITHOUT_PREDECESSOR  }
  validates_length_of :outgoing_control_flows, is: 0,      if: ->{ element.class.in? ProcessElement::ELEMENTS_WITHOUT_SUCCESSOR    }
end
