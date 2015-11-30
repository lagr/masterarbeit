module HasManyPredecessors
  extend ActiveSupport::Concern

  included do
    has_many :incoming_control_flows, foreign_key: 'successor_id', class_name: 'ControlFlow', dependent: :destroy
  end

  def predecessors
    incoming_control_flows.map(&:predecessor)
  end
end
