module IsWorkflowElement
  extend ActiveSupport::Concern

  included do
    #belongs_to :workflow_version#, as: :workflow_element
    has_one :workflow_element, as: :element
    has_one :workflow_version, through: :workflow_element
    has_one :workflow_element_representation, through: :workflow_element
  end
end
