Rails.application.routes.draw do
  resources :servers, only: [:index, :show], param: :name
end
