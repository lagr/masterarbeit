Rails.application.routes.draw do
  root 'application#index'
  get 'templates/*template', to: 'templates#serve'
  get '*path', to: 'application#index'
end
