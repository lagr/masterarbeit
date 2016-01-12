module IsPartOfProcess
  extend ActiveSupport::Concern

  included do
    has_one :activity, as: :element
    has_one :workflow, through: :activity
    has_one :activity_representation, through: :activity
  end
end
