Rails.application.routes.draw do
  root to: 'application#index'
  resources :roles
  resources :users
  resources :servers
  resources :workflows
  resources :activities
  resources :process_definitions, only: [:show, :update]
end
