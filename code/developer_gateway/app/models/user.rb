class User < ActiveResource::Base
  self.site = 'http://organization:3000'
  self.include_root_in_json = true
  belongs_to :role
end
