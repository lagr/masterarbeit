class ProcessDefinition < ActiveRecord::Base
  belongs_to :workflow
  has_many :activities
  has_many :control_flows
end
