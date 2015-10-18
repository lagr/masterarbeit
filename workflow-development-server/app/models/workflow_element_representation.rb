class WorkflowElementRepresentation < ActiveRecord::Base
  belongs_to :workflow_element, polymorphic: true
  belongs_to :workflow_version, through: :workflow_element
end
