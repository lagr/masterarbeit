  class WorkflowVersion < ActiveRecord::Base
    has_and_belongs_to_many :workflow_bundles
    has_many :workflow_elements, polymorphic: true
  end