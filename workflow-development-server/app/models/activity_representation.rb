class ActivityRepresentation < ActiveRecord::Base
  belongs_to :activity
  has_one :workflow, through: :activity
end
