class Server < ActiveResource::Base
  self.site = 'http://infrastructure:3000'
  self.include_root_in_json = true
end
