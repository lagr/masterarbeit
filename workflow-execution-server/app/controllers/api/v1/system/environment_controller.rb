module Api::V1 
  class System::EnvironmentController < Api::ApiController
    def set_repository
      return unless params[:repository].present?
      
      @config = Configuration.current
      @config.settings.repository = params[:repository]

      if @config.save
        render json: {}, status: :ok
      else
        render json: {}, status: :error
      end
    end
  end
end
