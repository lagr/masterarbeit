class WorkflowVersionFullSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
  belongs_to :workflow
  has_one :process_definition, serializer: ProcessDefinitionSerializer
end
