module HasManySuccessors
  extend ActiveSupport::Concern

  included do
    has_many :outgoing_control_flows, foreign_key: 'predecessor_id', class_name: 'ControlFlow'
    Workflow::WORKFLOW_ELEMENT_TYPES.each do |type|
      has_many type.pluralize.underscore.to_sym, through: :outgoing_control_flows, source: :predecessor, source_type: type
    end
  end

  def successors
    outgoing_control_flows
  end
end
