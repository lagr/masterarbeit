class ProcessDefinition < ActiveRecord::Base
  belongs_to :workflow
  has_many :activities
  has_many :control_flows, through: :activities, source: 'incoming_control_flows'
end
