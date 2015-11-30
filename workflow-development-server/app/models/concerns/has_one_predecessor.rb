module HasOnePredecessor
  extend ActiveSupport::Concern

  included do
    has_many :incoming_control_flows, foreign_key: 'successor_id', class_name: 'ControlFlow', dependent: :destroy
    validates_length_of :incoming_control_flows, maximum: 1
  end

  def predecessor
    incoming_control_flows.first.predecessor
  end
end
