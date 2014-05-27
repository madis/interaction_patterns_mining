Rails.application.routes.draw do
  root to: 'dashboard#index'

  resources :visitors do
    get 'simulate'
  end
  get 'dashboard/index'
  get '/new_simulation', to: 'visitors#new_simulation'
  get 'metrics_events/create'
  match '/about', to: 'application#about', via: :get
end
