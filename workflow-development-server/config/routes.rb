Rails.application.routes.draw do
  root 'application#index'
  
  resources :workflows, :workflow_versions, :users, :workflow_bundles
  #get 'workflows/:id', to: 'application#workflow'
  get 'templates/*template', to: 'templates#serve'
  #get '*path', to: 'application#index'
end
