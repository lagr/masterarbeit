module HasActivityRepresentation
  extend ActiveSupport::Concern

  included do
    has_one :activity_representation
  end
end
