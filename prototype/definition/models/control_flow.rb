class ControlFlow < ActiveRecord::Base
  belongs_to :successor,    class_name: 'Activity', inverse_of: :incoming_control_flows, validate: true
  belongs_to :predecessor,  class_name: 'Activity', inverse_of: :outgoing_control_flows, validate: true
  belongs_to :process_definition

  default_scope ->{ order(:created_at) }

  validates_presence_of :successor, :predecessor
end
