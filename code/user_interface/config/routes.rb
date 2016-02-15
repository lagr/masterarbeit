Rails.application.routes.draw do
  root to: 'users#index'
  resources :worklists, only: [:index, :show]
  resources :worklist_items, except: :create
end
