class Workflow < ActiveRecord::Base
  has_and_belongs_to_many :workflow_bundles
  has_one :process_definition
  has_many :process_elements, through: :process_definition
  before_create :build_process_definition

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  def required_images
    [
      WorkflowImageManager.image_name_for(types: process_elements.map(&:element_type).uniq),
      process_elements.container_activities.map(&:element).map(&:image).uniq + process_elements.containerized_activities.map(&:element).map(&:image).uniq,
      process_elements.sub_workflow_activities.map(&:element).map(&:sub_workflow).map(&:required_images).uniq
    ].flatten.compact.uniq
  end
end
