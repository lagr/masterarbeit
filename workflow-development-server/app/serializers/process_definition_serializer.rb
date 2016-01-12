class ProcessDefinitionSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
  has_many :activities
  has_many :control_flows
end
