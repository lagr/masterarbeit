class WorkflowInstance < ActiveRecord::Base
  belongs_to :workflow
  has_one :process_instance
end
