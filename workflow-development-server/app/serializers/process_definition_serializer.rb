class ProcessDefinitionSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
  has_many :process_elements
  has_many :control_flows
end
