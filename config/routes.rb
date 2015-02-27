Rails.application.routes.draw do

  devise_for :users

  resource :settings, only: [:edit, :update]

  resources :projects do
    resources :stories do
      resources :comments
      resources :tasks
    end
  end

  root to: "projects#index"

end
