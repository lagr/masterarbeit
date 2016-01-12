class ProcessDefinitionImageSerializer < ActiveModel::Serializer
  has_many :activities, serializer: ActivityImageSerializer
end
