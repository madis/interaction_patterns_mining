Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :visitors do
    get 'simulate', on: :collection
  end
  get 'metrics_events/create'
end
