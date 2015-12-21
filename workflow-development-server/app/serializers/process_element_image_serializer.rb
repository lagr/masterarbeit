class ProcessElementImageSerializer < ActiveModel::Serializer
  attribute :element_id, key: :id
  attribute :element_type, key: :type
  has_many :outgoing_control_flows, key: :successors, embed: :id

  def outgoing_control_flows
    object.outgoing_control_flows.map(&:successor).collect(&:element_id)
  end
end
