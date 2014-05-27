Rails.application.routes.draw do
  root to: 'dashboard#index'

  resources :visitors do
    get 'simulate'
  end

  # resources :metrics_events
  post '/metrics_events', to: 'metrics_events#create'

  get 'dashboard/index'
  get '/new_simulation', to: 'visitors#new_simulation'
  match '/about', to: 'application#about', via: :get
end
