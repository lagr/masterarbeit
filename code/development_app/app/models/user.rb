class User < ActiveRecord::Base
  belongs_to :role
  has_many :workflows

  def name
    "#{last_name}, #{first_name}"
  end
end
