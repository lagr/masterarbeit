class WorkflowDeploymentSerializer < ActiveModel::Serializer
  attributes :id, :name, :image
  has_many :process_elements, key: :activities

  def image
    "wf_#{object.id}"
  end

  class ProcessElementSerializer < ActiveModel::Serializer
    attributes :id, :image

    def image
      "ac_#{object.id}"
    end
  end
end
