class ProcessDefinitionImageSerializer < ActiveModel::Serializer
  has_many :activities

  class ActivitySerializer < ActiveModel::Serializer
    attribute :activity_type, key: :type
    has_many :outgoing_control_flows, key: :successors

    def outgoing_control_flows
      object.outgoing_control_flows.collect(&:successor_id)
    end
  end
end
