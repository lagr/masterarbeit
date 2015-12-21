module Api::V1::Docker
  class DockerController < Api::ApiController
    ImageStruct = Struct.new(:id, :name)

    def status
      render json: { available: Docker.version.present? }
    end

    def index_installed_images
      @images = Docker::Image.all.collect do |image| 
        ImageStruct.new image.id, image.info['RepoTags'].last  
      end
      render json: @images
    end

    def install_image
      @installation = install_images_by_identifiers(identifiers)
      if @installation[:failed].empty?
        render json: {}, status: :ok
      else
        render json: {}, status: :error
      end
    end

    def install_images
      @installation = install_images_by_identifiers(identifiers)
      render json: @installation, status: @installation[:failed].empty? ? :ok : :error
    end

    def index_containers
      filter = params[:status] == 'running' ? {} : { all: true }
      begin
        @containers = Docker::Container.all(filter)
      rescue
        return render status: 500
      end

      render json: @containers, status: @containers ? :ok : :error
    end

    def stop_container
    end

    private

    def identifiers
      params[:image].present? ? [params[:image]] : params[:images] if identifiers.empty?
    end
  end
end
