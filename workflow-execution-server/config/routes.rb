Rails.application.routes.draw do
  root 'application#index'
  get :status, to: 'application#status'

  namespace :api do
    namespace :v1 do
      
      namespace :organization do
        resources :roles
        resources :users
      end

      namespace :workflow_management do
        resources :events
        
        get '/workflows/', to: 'workflows#index'
        post '/workflows/', to: 'workflows#install'
        post '/workflows/:id', to: 'workflows#install'
        delete '/workflows/:id', to: 'workflows#uninstall'
        
        get '/workflow_instances/', to: 'workflow_instances#index'
        post '/workflow_instances/', to: 'workflow_instances#create'
      end

      namespace :system do
        patch '/repository', to: 'environment#set_repository'
      end

      namespace :docker do
        get '/status', to: 'docker#status'

        get '/installed_images', to: 'docker#index_installed_images'
        post '/install_image', to: 'docker#install_image'
        post '/install_images', to: 'docker#install_images'

        get '/index_containers', to: 'docker#index_containers'
        patch '/stop_container', to: 'docker#stop_container'
      end
    end
  end

  namespace :frontend do
  end
end
