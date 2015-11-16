  class WorkflowVersion < ActiveRecord::Base
    belongs_to :workflow
    has_and_belongs_to_many :workflow_bundles
    has_many :process_elements
    has_one :process_definition
    before_create :build_process_definition

    def name
      "#{version}.#{subversion}.#{subsubversion}"
    end
  end
