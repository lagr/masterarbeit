class Activity < ActiveRecord::Base
  ACTIVITY_TYPES         = %w[StartActivity EndActivity OrSplitActivity OrJoinActivity AndSplitActivity AndJoinActivity ManualActivity AutomaticActivity ContainerizedActivity ContainerActivity SubWorkflowActivity]
  ELEMENTS_WITH_ONE_SUCCESSOR   = [StartActivity, AndJoinActivity, OrJoinActivity, ManualActivity, AutomaticActivity, ContainerizedActivity, ContainerActivity, SubWorkflowActivity]
  ELEMENTS_WITHOUT_SUCCESSOR    = [EndActivity]
  ELEMENTS_WITH_ONE_PREDECESSOR = [EndActivity, ManualActivity, AutomaticActivity, ContainerizedActivity, ContainerActivity, SubWorkflowActivity]
  ELEMENTS_WITHOUT_PREDECESSOR  = [StartActivity]

  belongs_to :process_definition
  belongs_to :element, polymorphic: true
  has_one :activity_representation, dependent: :destroy
  before_create :build_activity_representation

  store_accessor :input_schema
  
  include HasManyPredecessors
  include HasManySuccessors

  validates_length_of :incoming_control_flows, maximum: 1, if: ->{ element.class.in? Activity::ELEMENTS_WITH_ONE_PREDECESSOR }
  validates_length_of :outgoing_control_flows, maximum: 1, if: ->{ element.class.in? Activity::ELEMENTS_WITH_ONE_SUCCESSOR   }
  validates_length_of :incoming_control_flows, is: 0,      if: ->{ element.class.in? Activity::ELEMENTS_WITHOUT_PREDECESSOR  }
  validates_length_of :outgoing_control_flows, is: 0,      if: ->{ element.class.in? Activity::ELEMENTS_WITHOUT_SUCCESSOR    }

  ACTIVITY_TYPES.each do |type|
    scope type.pluralize.underscore.to_sym, ->{ where(activity_type: type) }
  end
end
