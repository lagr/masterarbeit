module HasManyPredecessors
  extend ActiveSupport::Concern

  included do
    has_many :incoming_control_flows, foreign_key: 'successor_id', class_name: 'ControlFlow'
    Workflow::WORKFLOW_ELEMENT_TYPES.each do |type|
      has_many type.pluralize.underscore.to_sym, through: :incoming_control_flows, source: :predecessor, source_type: type
    end
  end

  def predecessors
    incoming_control_flows
  end
end
