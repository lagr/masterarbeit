module HasOneSuccessor
  extend ActiveSupport::Concern

  included do
    has_many :outgoing_control_flows, foreign_key: 'predecessor_id', class_name: 'ControlFlow'
    validates_length_of :outgoing_control_flows, maximum: 1
  end

  def successor
    outgoing_control_flows.first.successor
  end
end
