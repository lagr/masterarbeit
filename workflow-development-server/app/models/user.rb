class User < ActiveRecord::Base
  belongs_to :role
  has_many :workflows
end
