class DataSchema < ActiveRecord::Base
  belongs_to :data_schema_owner, polymorphic: true
  store_accessor :template
  
  def is_valid_instance?(record)
  end
end
