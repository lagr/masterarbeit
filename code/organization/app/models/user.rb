class User < ActiveRecord::Base
  belongs_to :role
  scope :with_role, ->(role_id){ where(role_id: role_id) }
end
