class WorkflowElementSerializer < ActiveModel::Serializer
  attributes :id, :element_type, :representation, :created_at, :updated_at
  attribute :element, key: :element_data

  def representation
    object.element.workflow_element_representation
  end
end
