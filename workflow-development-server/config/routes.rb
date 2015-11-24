Rails.application.routes.draw do
  root 'application#index'
  
  resources :workflows, :workflow_versions, :users, :workflow_bundles 
  resources :control_flows, only: [:create, :destroy]
  resources :process_element_representations, only: [:update]

  resources :servers do
    member do
      get :index_images, to: 'servers#index_images'
    end
  end

  get 'templates/*template', to: 'templates#serve'
end
