Rails.application.routes.draw do
  root to: 'visitors#index'

  resources :visitors do
    get 'simulate', on: :collection
  end

  get '/simulate', to: 'visitors#simulate'
  get 'metrics_events/create'
  match '/about', to: 'application#about', via: :get
end
