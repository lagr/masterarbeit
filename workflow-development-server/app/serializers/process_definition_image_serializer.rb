class ProcessDefinitionImageSerializer < ActiveModel::Serializer
  has_many :process_elements, key: :activities, serializer: ProcessElementImageSerializer
end
