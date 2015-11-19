class Assignment < ActiveRecord::Base
  belongs_to :assigned_role, class_name: 'Role', foreign_key: 'role_id'
  belongs_to :assignable, polymorphic: true
end
