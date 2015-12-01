class WorklistItem < ActiveRecord::Base
  belongs_to :worklist
  belongs_to :activity_instance
  has_one :user, through: :worklist
  has_one :workflow_instance, through: :activity_instance
  has_one :process_instance, through: :activity_instance
end
