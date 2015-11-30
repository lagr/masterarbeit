class ControlFlow < ActiveRecord::Base
  belongs_to :successor,    class_name: 'ProcessElement', inverse_of: :incoming_control_flows, validate: true
  belongs_to :predecessor,  class_name: 'ProcessElement', inverse_of: :outgoing_control_flows, validate: true
  has_one :process_definition, through: :predecessor

  default_scope ->{ order(:created_at) }

  validates_presence_of :successor, :predecessor
end
