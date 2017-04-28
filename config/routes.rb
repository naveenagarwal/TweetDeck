Rails.application.routes.draw do

  resources :document, only: [:index, :create]
  resources :profiles, only: [:index, :edit, :update]

  # get 'omniauth_session/create'

  devise_for :users
  resources :posts do
    collection do
      put :bulk_update
      put :bulk_dequeue
      delete :bulk_destroy
    end
  end

  resources :campaigns

  root to: "home#index"

  get '/auth/:provider/callback', to: "omniauth_session#create"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # sidekiq monitoring
  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web, at: "/sidekiq"
  end
  # mount Sidekiq::Web => '/sidekiq'
end
