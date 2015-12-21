Rails.application.routes.draw do
  root 'application#index'
  
  resources :control_flows, only: [:create, :destroy]
  resources :process_element_representations, only: [:update]
  resources :process_elements
  resources :workflow_bundles
  resources :workflows

  resources :servers do
    member do
      get :status, to: 'servers#status'
      get :index_images, to: 'servers#index_images'
      post :deploy_workflow_bundles, to: 'servers#deploy_workflow_bundles'
    end
  end

  resources :users do
    resources :worklist, only: :show
  end

  get 'templates/*template', to: 'templates#serve'
end
