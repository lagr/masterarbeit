class ServerSerializer < ActiveModel::Serializer
  attributes :id, :name, :ip
  #attribute :reachable?, key: :reachable
  #attribute :docker_available?, key: :docker
end
