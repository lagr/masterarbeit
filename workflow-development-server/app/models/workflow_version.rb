  class WorkflowVersion < ActiveRecord::Base
    belongs_to :workflow
    has_and_belongs_to_many :workflow_bundles
    has_many :workflow_elements#, polymorphic: true
  end
