require 'hutch'
require 'docker-api'

module ServerManager
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
    end
  end

  class ImageConsumer
    include Hutch::Consumer
    consume 'wfms.image.#'

    def process(message)
      case message.routing_key.remove('wfms.image.')
      when 'add'
        update_image_if_assigned(message[:image])
      end
    end

    def update_image_if_assigned(image)
      if Docker::Image.exist?(image)
        Docker::Image.create 'fromImage' => image
      end
    end
  end
end
