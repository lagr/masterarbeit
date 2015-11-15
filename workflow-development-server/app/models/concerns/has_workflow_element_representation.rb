module HasProcessElementRepresentation
  extend ActiveSupport::Concern

  included do
    has_one :process_element_representation
  end
end
