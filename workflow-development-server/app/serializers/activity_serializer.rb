class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :activity_type, :representation, :created_at, :updated_at
  attribute :element, key: :element_data

  def representation
    object.element.activity_representation
  end
end
