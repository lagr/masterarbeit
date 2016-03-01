Rails.application.routes.draw do
  root to: 'worklists#index'
  resources :worklists, only: :index
  resources :worklist_items, except: [:create, :show]
end
