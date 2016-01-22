require 'httparty'

module UsersRolesServiceClient
  module User
    extend self
    User = Struct.new :id, :first_name, :last_name, :role_id

    def index
      response = HTTParty.get 'http://organization_service_1:3000/users.json'
      users = response.parsed_response
      users.collect do |user|
        User.new(user['id'], user['first_name'], user['last_name'], user['role_id'])
      end
    end

    def new
      User.new
    end

    def get(id)
      response = HTTParty.get "http://organization_service_1:3000/users/#{id}.json"
      user = response.parsed_response
      User.new(user['id'], user['first_name'], user['last_name'], user['role_id'])
    end

    def delete(id)
      HTTParty.delete "http://organization_service_1:3000/users/#{id}.json"
    end
  end

  module Role
    Role = Struct.new :id, :name, :parent_role_id

  end
end
