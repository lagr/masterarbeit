Rails.application.routes.draw do
  resources :control_flows, except: [:new, :edit]
  resources :activities, except: [:new, :edit]
  resources :process_definitions, except: [:new, :edit]
  resources :workflows, except: [:new, :edit]
end
