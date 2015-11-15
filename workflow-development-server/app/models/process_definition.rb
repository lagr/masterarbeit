class ProcessDefinition < ActiveRecord::Base
  belongs_to :workflow_version
  has_many :process_elements
  has_many :control_flows
end
