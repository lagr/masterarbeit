class Role < ActiveRecord::Base
  has_many :users
  belongs_to :parent_role, class_name: 'Role', foreign_key: 'parent_role_id'
  has_many :children_roles, class_name: 'Role', foreign_key: 'parent_role_id'

  def ancestors
    return [] if parent_role.nil?
    subject, ancestors = self, []
    ancestors << subject = subject.parent_role while subject.parent_role
  end
end
