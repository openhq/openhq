Rails.application.routes.draw do

  devise_for :users

  # First time setup
  get '/setup' => 'setup#new'
  post '/setup' => 'setup#create'
  get '/setup/complete' => 'setup#complete'

  resource :account, only: [:edit, :update, :destroy], controller: :account
  resource :settings, only: [:edit, :update]

  resources :team, only: [:index, :edit]

  resources :projects do
    resources :stories do
      resources :comments
      resources :tasks
      resources :attachments
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root to: "projects#index"

end
