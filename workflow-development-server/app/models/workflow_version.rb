  class WorkflowVersion < ActiveRecord::Base
    belongs_to :workflow
    has_and_belongs_to_many :workflow_bundles
    has_many :process_elements
    has_one :process_definition
    
    has_one :data_schema, as: :data_schema_owner

    before_create :build_process_definition

    validates_presence_of :workflow#, :process_definition, :version, :subversion, :subsubversion
  end
