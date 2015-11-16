class WorkflowBundle < ActiveRecord::Base
  has_and_belongs_to_many :workflow_versions
end