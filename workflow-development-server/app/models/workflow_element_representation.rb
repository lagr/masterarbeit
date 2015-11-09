class WorkflowElementRepresentation < ActiveRecord::Base
  belongs_to :workflow_element
  belongs_to :workflow_version, through: :workflow_element
end
