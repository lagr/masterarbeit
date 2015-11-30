module HasManySuccessors
  extend ActiveSupport::Concern

  included do
    has_many :outgoing_control_flows, foreign_key: 'predecessor_id', class_name: 'ControlFlow', dependent: :destroy
  end

  def successors
    outgoing_control_flows.map(&:succesor)
  end
end
