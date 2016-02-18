class ControlFlow < ActiveResource::Base
  self.site = 'http://definition:3000'
  self.include_root_in_json = true

  has_many :activities
  belongs_to :successor, class_name: 'Activity', foreign_key: 'successor_id'
  belongs_to :predecessor, class_name: 'Activity', foreign_key: 'predecessor_id'
  belongs_to :process_definition
end
