module ImageManager
  extend self
  SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze

  def export_workflow(workflow)
    elements = [workflow] + workflow.child_elements.flatten.compact
    publish_third_party_images(workflow.required_images.flatten.compact)

    images = ImageBuilder.build_images(elements)
    images[:successful].each { |built_image| publish_image(built_image[:subject], built_image[:image]) }
    images[:failed].empty?
  end

  def image_name(type:, id: 'base')
    "#{SHORT_TYPES[type]}_#{id}"
  end

  private

  def publish_third_party_images(images)
    images.each do |img|
      image = Docker::Image.create fromImage: "#{img[:name]}:#{img[:version]}"
      repo_tag = "#{registry_address}/#{img[:name]}"
      image.tag(repo: repo_tag, tag: img[:version], force: true)
      image.push(nil, repo_tag: "#{repo_tag}:#{img[:version]}") {|status| puts status }
    end
  end

  def registry_address
    cluster_store = URI.parse(Docker.info['ClusterStore'])
    cluster_store.port = 5000
    cluster_store.select(:host,:port).join(':')
  end

  def publish_image(subject, image)
    type = subject.class.name.underscore.to_sym
    image_name = image_name(type: type, id: subject.id)
    repo_tag = "#{registry_address}/#{type}"

    image.tag(repo: repo_tag, tag: image_name, force: true)
    image.push(nil, repo_tag: "#{repo_tag}:#{image_name}") {|status| puts status }
  end
end
