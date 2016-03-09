class DockerConsumer
  include Hutch::Consumer
  consume 'wfms.docker.#'

  def process(message)
    subject, action, subject_id = /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)

    if action == :index
      images = Docker::Image.search(term: message[:term]).map(&:id)
      Hutch.publish "wfms.docker.indexed", images: images.as_json
    end
  end
end
