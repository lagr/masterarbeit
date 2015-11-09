class WorkflowVersionFullSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
  belongs_to :workflow
  has_many :workflow_elements
end
