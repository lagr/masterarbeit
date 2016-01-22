class Workflow < ActiveRecord::Base
  has_one :process_definition
  before_create :build_process_definition
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :activities, through: :process_definition
  has_and_belongs_to_many :servers

  def required_images
    activities.map(&:required_images).flatten
  end
end
