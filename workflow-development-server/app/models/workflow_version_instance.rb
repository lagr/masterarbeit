class WorkflowVersionInstance < ActiveRecord::Base
  belongs_to :workflow_version
  has_one :process_instance
end
