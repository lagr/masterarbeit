Rails.application.routes.draw do
  root 'application#index'

  namespace :api do
    namespace :v1 do

      namespace :organization do
        resources :roles
        resources :users
      end

      namespace :workflow_management do
        get '/workflows/', to: 'workflows#index'
        post '/workflows/:id', to: 'workflows#install'
        delete '/workflows/:id', to: 'workflows#uninstall'
        
        post 'workflow_instances', to: 'workflow_instances#create'
      end

      namespace :system do
        patch '/repository', to: 'environment#set_repository'
      end

      namespace :docker do
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
