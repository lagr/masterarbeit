Rails.application.routes.draw do
  root 'application#index'
  
  resources :workflows, :workflow_versions, :users, :workflow_bundles 

  resources :process_element_representations, only: [:update]

  get 'templates/*template', to: 'templates#serve'
end
