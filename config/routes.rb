Rails.application.routes.draw do
  resources :movies
  resource :landing, only: [:show]

  root to: 'landings#show'
end
