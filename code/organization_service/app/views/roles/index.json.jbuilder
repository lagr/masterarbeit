json.array!(@roles) do |role|
  json.extract! role, :id, :id, :name, :parent_role_id
  json.url role_url(role, format: :json)
end
