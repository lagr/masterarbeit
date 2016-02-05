require 'hutch'
require 'docker-api'

module Provisioner
  def self.match_message(message)
    /wfms\.(\w+)\.(\w+)(?:\.([\w-]+))?/.match(message.routing_key).captures.to_a.compact.map(&:to_sym)
  end

  class ServerConsumer
    include Hutch::Consumer
    consume 'wfms.server.#'

    def process(message)
      case message.routing_key.remove('wfms.server.')
      when 'update'
        reconfigure_environment(message[:server])
      end
    end

    def reconfigure_environment(server)
      server[:required_images].each do |image|
        Docker::Image.create 'Image' => "#{image[:tag]}:latest"
      end
      server[:enviroment_containers].each do |cont|
        Docker::Container.create(cont['configuration'])
      end
    end
  end

  class ImageConsumer
    include Hutch::Consumer
    consume 'wfms.image.#'

    def process(message)
      subject, action, subject_id = Provisioner.match_message(message)
      case action
      when :add
        update_image_if_assigned(message[:image])
      end
    end

    def update_image_if_assigned(image)
      if assigned?(image)
        Docker::Image.create 'fromImage' => image
      end
    end

    def assigned?(image)
      true
    end
  end
end
