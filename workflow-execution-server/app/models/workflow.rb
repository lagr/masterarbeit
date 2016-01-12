class Workflow < ActiveRecord::Base
  has_and_belongs_to_many :workflow_bundles
  has_one :process_definition
  has_many :activities, through: :process_definition
  before_create :build_process_definition

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  def required_images
    [
      WorkflowImageManager.image_name_for(types: activities.map(&:activity_type).uniq),
      activities.container_activities.map(&:element).map(&:image).uniq + activities.containerized_activities.map(&:element).map(&:image).uniq,
      activities.sub_workflow_activities.map(&:element).map(&:sub_workflow).map(&:required_images).uniq
    ].flatten.compact.uniq
  end
end
