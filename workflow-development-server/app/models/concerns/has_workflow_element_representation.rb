module HasWorkflowElementRepresentation
  extend ActiveSupport::Concern

  included do
    has_one :workflow_element_representation
  end
end
