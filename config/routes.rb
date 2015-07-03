require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users

  # First time setup
  get '/setup' => 'setup#new'
  post '/setup' => 'setup#create'
  get '/setup/complete' => 'setup#initial_setup', as: :initial_setup
  post '/setup/complete' => 'setup#complete'

  resource :account, only: [:edit, :update, :destroy], controller: :account
  resource :settings, only: [:edit, :update]

  resources :files, only: :index
  resources :team, only: [:index, :new, :create, :edit]

  resources :projects do
    resources :stories do
      resources :comments
      resources :tasks do
        put "update-order", on: :collection
      end
      resources :attachments
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Use devise to ensure user is signed in as an admin
  authenticate :user, lambda { |u| u.role?(:owner) } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: "projects#index"

end
