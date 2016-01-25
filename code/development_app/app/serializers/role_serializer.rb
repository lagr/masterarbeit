class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_role_id
  has_many :users
  has_many :child_roles
end
