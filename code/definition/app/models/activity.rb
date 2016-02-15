class Activity < ActiveRecord::Base
  ACTIVITY_TYPES = [:manual, :automatic, :container, :subworkflow].freeze
  ACTIVITY_TYPES.each { |type| scope "#{type}_activities", ->{ where(activity_type: type) } }

  belongs_to :process_definition
  belongs_to :subworkflow, class_name: 'Workflow', foreign_key: 'subworkflow_id'

  store_accessor :input_schema
  store_accessor :output_schema
  store_accessor :activity_configuration
  store_accessor :representation

  has_many :incoming_control_flows, foreign_key: 'successor_id', class_name: 'ControlFlow', dependent: :destroy
  has_many :outgoing_control_flows, foreign_key: 'predecessor_id', class_name: 'ControlFlow', dependent: :destroy

  validates :activity_type, inclusion: { in: ACTIVITY_TYPES.map(&:to_s) }

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
