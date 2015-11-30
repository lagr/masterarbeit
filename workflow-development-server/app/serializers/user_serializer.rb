class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :role, :created_at, :updated_at
  has_one :worklist
end
