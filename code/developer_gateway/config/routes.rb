Rails.application.routes.draw do
  root to: 'application#index'
  resources :roles
  resources :users
  get 'templates/*template', to: 'templates#serve'
end
