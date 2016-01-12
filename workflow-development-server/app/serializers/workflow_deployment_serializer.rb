class WorkflowDeploymentSerializer < ActiveModel::Serializer
  attributes :id, :name, :image
  has_many :activities

  def image
    "wf_#{object.id}"
  end

  class ActivitySerializer < ActiveModel::Serializer
    attributes :id, :image

    def image
      "ac_#{object.id}"
    end
  end
end
