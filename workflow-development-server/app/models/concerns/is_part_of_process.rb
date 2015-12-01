module IsPartOfProcess
  extend ActiveSupport::Concern

  included do
    has_one :process_element, as: :element
    has_one :workflow, through: :process_element
    has_one :process_element_representation, through: :process_element
  end
end
