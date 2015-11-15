class ProcessElementRepresentation < ActiveRecord::Base
  belongs_to :process_element
  has_one :workflow_version, through: :process_element
end
