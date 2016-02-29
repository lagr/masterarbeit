Rails.application.routes.draw do
  root to: 'users#index'
  resources :worklists, only: :index
  resources :worklist_items, except: [:create, :show]
end
