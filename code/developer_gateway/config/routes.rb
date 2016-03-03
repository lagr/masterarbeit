Rails.application.routes.draw do
  root to: 'application#index'
  resources :roles
  resources :users
  resources :servers, only: [:index, :show], param: :name
  resources :workflows do
    member do
      patch '/start', to: 'workflows#start_instance'
    end
  end
  resources :process_definitions
  resources :activities
  resources :control_flows
  get 'templates/*template', to: 'templates#serve'
end
