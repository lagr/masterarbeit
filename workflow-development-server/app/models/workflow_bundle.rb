class WorkflowBundle < ActiveRecord::Base
  has_and_belongs_to_many :workflows
  has_and_belongs_to_many :servers

  def required_images
    workflows.map(&:required_images).flatten.uniq
  end
end
