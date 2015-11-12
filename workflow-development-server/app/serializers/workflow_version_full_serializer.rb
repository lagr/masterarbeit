class WorkflowVersionFullSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
  belongs_to :workflow
  has_many :workflow_elements
  has_many :control_flows

  def workflow_elements
    object.workflow_elements.where.not(element_type: 'ControlFlow')
  end

  def control_flows
    object.workflow_elements.where(element_type: 'ControlFlow')
  end
end
