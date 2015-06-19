Rails.application.routes.draw do

  devise_for :users

  # First time setup
  get '/setup' => 'setup#new'
  post '/setup' => 'setup#create'
  get '/setup/complete' => 'setup#complete'

  resource :settings, only: [:edit, :update]

  resources :team

  resources :projects do
    resources :stories do
      resources :comments
      resources :tasks
      resources :attachments
    end
  end

  root to: "projects#index"

end
