class DataSchema < ActiveRecord::Base
  belongs_to :data_schema_owner, polymorphic: true
  
  def is_valid_instance?(record)
  end
end
