module Api::V1 
  class System::EnvironmentController < Api::ApiController
    def set_repository
      @config = Configuration.current
      @config.settings.repository = params[:repository]
      render json: {}, status: :ok
    end
  end
end
