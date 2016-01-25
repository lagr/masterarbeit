class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :role_id
  belongs_to :role
end
