class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_role_id
end
