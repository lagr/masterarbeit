class WorklistSerializer < ActiveModel::Serializer
  attributes :id
  has_many :worklist_items
end
