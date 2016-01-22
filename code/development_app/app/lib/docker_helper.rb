require 'resolv'

module DockerHelper
  extend self
  SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze

  def registry_ip
    Resolv.getaddress 'registry_service_1'
  end

  def image_name(type:, id: 'base')
    "#{SHORT_TYPES[type]}_#{id}"
  end
end
