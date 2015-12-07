class DockerController < Api::ApiController
  def index_installed_images
    images = Docker::Image.all
    byebug
  end

  def install_image
  end

  def install_images
  end


  def index_running_containers
  end

  def stop_container
  end

end
