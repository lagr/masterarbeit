class Workflow < ActiveResource::Base
  self.site = 'http://definition:3000'
  self.include_root_in_json = true
end
