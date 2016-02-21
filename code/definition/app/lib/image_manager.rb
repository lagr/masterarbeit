module ImageManager
  extend self
  SHORT_TYPES = { activity: 'ac', workflow: 'wf' }.freeze

  def export_workflow(workflow)
    images = ImageBuilder.build_images([workflow] + workflow.activities + workflow.activities.map(&:child_elements).flatten)
    images[:successful].each { |built_image| publish_image(built_image[:subject], built_image[:image]) }
    images[:failed].empty?
  end

  def image_name(type:, id: 'base')
    "#{SHORT_TYPES[type]}_#{id}"
  end

  private

  def publish_image(subject, image)
    type = subject.class.name.underscore.to_sym
    image_name = image_name(type: type, id: subject.id)
    repo_tag = "192.168.99.100:5000/#{type}"

    image.tag(repo: repo_tag, tag: image_name, force: true)
    image.push(nil, repo_tag: "#{repo_tag}:#{image_name}") {|status| puts status }

    Hutch.publish 'wfms.image.pushed', image: "#{repo_tag}:#{image_name}"
  end
end
