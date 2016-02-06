module ImageManager
  extend self

  def export_workflow(workflow)
    images = ImageBuilder.build_images([workflow] + workflow.activities)
    images[:successful].each { |built_image| publish_image(built_image[:subject], built_image[:image]) }
    images[:failed].empty?
  end

  private

  def publish_image(subject, image)
    type = subject.class.name.underscore.to_sym
    image_name = DockerHelper.image_name(type: type, id: subject.id)
    repo_tag = "192.168.99.100:5000/#{type}"
    image.tag(repo: repo_tag, tag: image_name, force: true)
    image.push(nil, repo_tag: "#{repo_tag}:#{image_name}") {|status| puts status }

    MessageService.publish :image, :add, image: "#{repo_tag}:#{image_name}"
  end
end
