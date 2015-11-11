class WorkflowElementSerializer < ActiveModel::Serializer
  attributes :id, :element_type, :element_representation, :created_at, :updated_at
  attribute :element, key: :element_data
  
  def element_data
    object.element
  end

  def element_representation
    object.element.workflow_element_representation
  end
end
