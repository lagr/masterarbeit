class ProcessDefinition < ActiveResource::Base
  self.site = 'http://definition:3000'
  self.include_root_in_json = true

  belongs_to :workflow
  has_many :activities
end
