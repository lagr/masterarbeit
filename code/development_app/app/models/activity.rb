class Activity < ActiveRecord::Base
  ACTIVITY_TYPES = [:start, :end, :orsplit, :orjoin, :andsplit, :andjoin, :manual, :automatic, :container, :subworkflow].freeze
  ELEMENTS_WITH_ONE_SUCCESSOR   = [:start, :andjoin, :orjoin, :manual, :automatic, :container, :subworkflow].freeze
  ELEMENTS_WITHOUT_SUCCESSOR    = [:end].freeze
  ELEMENTS_WITH_ONE_PREDECESSOR = [:end, :manual, :automatic, :containerized, :container, :subworkflow].freeze
  ELEMENTS_WITHOUT_PREDECESSOR  = [:start].freeze

  belongs_to :process_definition
  belongs_to :subworkflow
  has_many :assignments

  store_accessor :input_schema
  store_accessor :output_schema
  store_accessor :activity_configuration
  store_accessor :representation

  has_many :incoming_control_flows, foreign_key: 'successor_id', class_name: 'ControlFlow', dependent: :destroy
  has_many :outgoing_control_flows, foreign_key: 'predecessor_id', class_name: 'ControlFlow', dependent: :destroy

  validates :activity_type, inclusion: { in: ACTIVITY_TYPES }
  validates_length_of :incoming_control_flows, maximum: 1, if: ->{ activity_type.in? Activity::ELEMENTS_WITH_ONE_PREDECESSOR }
  validates_length_of :outgoing_control_flows, maximum: 1, if: ->{ activity_type.in? Activity::ELEMENTS_WITH_ONE_SUCCESSOR   }
  validates_length_of :incoming_control_flows, is: 0,      if: ->{ activity_type.in? Activity::ELEMENTS_WITHOUT_PREDECESSOR  }
  validates_length_of :outgoing_control_flows, is: 0,      if: ->{ activity_type.in? Activity::ELEMENTS_WITHOUT_SUCCESSOR    }

  ACTIVITY_TYPES.each { |type| scope "#{type}_activities", ->{ where(activity_type: type) } }

  def required_images
    case activity_type
    when :container
      image_with_version
    when :subworkflow
      subworkflow.required_images
    else nil
    end
  end

  def image_with_version
    { name: activity_configuration['image'], version: activity_configuration['image_version'] }
  end

  def predecessors
    incoming_control_flows.map(&:predecessor)
  end

  def successors
    outgoing_control_flows.map(&:succesor)
  end
end
