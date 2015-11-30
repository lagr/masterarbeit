class User < ActiveRecord::Base
  belongs_to :role
  has_many :workflows
  has_one :worklist, dependent: :destroy
  before_create :build_worklist
  has_many :worklist_items, through: :worklist
end
