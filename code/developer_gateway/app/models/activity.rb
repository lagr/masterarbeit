class Activity < ActiveResource::Base
  self.site = 'http://definition:3000'
  self.include_root_in_json = true

  belongs_to :process_definition
  belongs_to :subworkflow, class_name: 'Workflow', foreign_key: 'subworkflow_id'
end
