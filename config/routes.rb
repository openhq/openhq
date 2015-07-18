require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users

  # First time setup
  get '/setup' => 'setup#new'
  post '/setup' => 'setup#create'
  get '/setup/complete' => 'setup#initial_setup', as: :initial_setup
  post '/setup/complete' => 'setup#complete'

  resource :account, only: [:edit, :update, :destroy], controller: :account

  resources :files, only: :index
  resources :team, only: [:index, :show, :new, :create, :edit]

  resources :projects do
    get "archived", on: :collection
    get "restore", on: :member
    resources :stories do
      get "archived", on: :collection
      get "restore", on: :member
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

  # Dynamic error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  root to: "projects#index"

end
