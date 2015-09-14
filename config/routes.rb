Rails.application.routes.draw do
  resources :movies, only: [:show, :index] do 
    get 'search/*query', to: 'movies#index', as: :search, on: :collection
  end

  resource :landing, only: [:show]

  root to: 'landings#show'
end
