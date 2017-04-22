Rails.application.routes.draw do

  resources :document, only: [:create]

  # get 'omniauth_session/create'

  devise_for :users
  resources :posts

  root to: "home#index"

  get '/auth/:provider/callback', to: "omniauth_session#create"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
