Rails.application.routes.draw do
  resources :roles, except: [:new, :edit]
  resources :users, except: [:new, :edit]
end
