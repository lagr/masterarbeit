class ControlFlow < ActiveRecord::Base
  belongs_to :process_definition
  belongs_to :successor, polymorphic: true, inverse_of: :incoming_control_flows
  belongs_to :predecessor, polymorphic: true, inverse_of: :outgoing_control_flows 
end
