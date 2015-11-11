class WorkflowElementRepresentation < ActiveRecord::Base
  belongs_to :workflow_element
  has_one :workflow_version, through: :workflow_element
end
