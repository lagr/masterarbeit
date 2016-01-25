class User < ActiveRecord::Base
  belongs_to :role
  has_many :workflows

  scope :with_role, ->(role_id){ where(role_id: role_id) }

  def name
    "#{last_name}, #{first_name}"
  end
end
