class Workflow < ActiveRecord::Base
  has_one :process_definition
  before_create :build_process_definition
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :activities, through: :process_definition

  def required_images
    activities.map(&:required_images).flatten
  end

  def child_elements
    activities + activities.map(&:child_elements)
  end
end
