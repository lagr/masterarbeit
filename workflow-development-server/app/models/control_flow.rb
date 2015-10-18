class ControlFlow < ActiveRecord::Base
  include IsWorkflowElement
  belongs_to :successor, polymorphic: true, inverse_of: :incoming_control_flows
  belongs_to :predecessor, polymorphic: true, inverse_of: :outgoing_control_flows 
end