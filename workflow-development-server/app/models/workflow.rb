class Workflow < ActiveRecord::Base
  PROCESS_ELEMENT_TYPES = %w[StartElement EndElement OrSplitElement OrJoinElement AndSplitElement ManualActivity AutomaticActivity ContainerizedActivity]
  has_and_belongs_to_many :workflow_bundles
  has_one :process_definition
  has_many :process_elements, through: :process_definition
  before_create :build_process_definition

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
end
