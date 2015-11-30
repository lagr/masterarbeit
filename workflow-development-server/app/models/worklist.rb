class Worklist < ActiveRecord::Base
  belongs_to :user
  has_many :worklist_items
end
