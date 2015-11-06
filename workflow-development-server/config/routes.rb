Rails.application.routes.draw do
  root 'application#index'

  get 'workflow/:id', to: 'application#workflow'
  get 'templates/*template', to: 'templates#serve'
  get '*path', to: 'application#index'
end
