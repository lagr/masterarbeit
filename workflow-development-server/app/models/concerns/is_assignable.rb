module IsAssignable
  extend ActiveSupport::Concern

  included do
    has_many :assignments, as: :assignable
    has_many :assigned_roles, through: :assignments, class_name: 'Role', foreign_key: 'role_id'
  end
end
