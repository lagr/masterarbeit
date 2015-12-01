class WorkflowFullSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
  has_one :process_definition, serializer: ProcessDefinitionSerializer
end
