class Workflow < ActiveRecord::Base
  WORKFLOW_ELEMENT_TYPES = %w[ StartElement EndElement OrSplitElement OrJoinElement AndSplitElement ManualActivity AutomaticActivity ContainerizedActivity ]

  has_many :workflow_versions
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
end
