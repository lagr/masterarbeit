class User < ActiveRecord::Base
  belongs_to :role
  has_many :workflows, foreign_key: :author_id
end
