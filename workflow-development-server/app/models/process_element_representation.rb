class ProcessElementRepresentation < ActiveRecord::Base
  belongs_to :process_element
  has_one :workflow, through: :process_element
end
