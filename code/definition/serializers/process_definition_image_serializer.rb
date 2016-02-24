class ProcessDefinitionImageSerializer < ActiveModel::Serializer
  has_many :activities

  class ActivitySerializer < ActiveModel::Serializer
    attribute :id
    attribute :activity_type, key: :type
    has_many :outgoing_control_flows, key: :successors
    has_many :incoming_control_flows, key: :predecessors

    def outgoing_control_flows
      object.outgoing_control_flows.collect(&:successor_id)
    end

    def incoming_control_flows
      object.incoming_control_flows.collect(&:predecessor_id)
    end
  end
end
