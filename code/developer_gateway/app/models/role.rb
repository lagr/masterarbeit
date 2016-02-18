class Role < ActiveResource::Base
  self.site = 'http://organization:3000'
  self.include_root_in_json = true

  has_many :users
end
