Rails.application.routes.draw do
  root to: 'application#index'

  resources :roles do
    resources :users
  end

  resources :users
  resources :servers
  resources :activities

  resources :workflows do
    member do
      get 'process_definition', to: 'process_definitions#edit'
      put 'process_definition', to: 'process_definitions#update'
    end
  end

  get '/dashboard/summary', to: 'dashboard#summary'

  get 'templates/*template', to: 'templates#serve'
end
