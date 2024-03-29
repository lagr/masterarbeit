class ProcessDefinition < ActiveRecord::Base
  belongs_to :workflow
  has_many :activities
  has_many :control_flows, through: :activities, source: 'incoming_control_flows'
  has_one :input_schema , class_name: 'DataSchema', as: :data_schema_owner
  has_one :output_schema, class_name: 'DataSchema', as: :data_schema_owner
end
