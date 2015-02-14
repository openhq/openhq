Rails.application.routes.draw do

  devise_for :users

  resources :projects do
    resources :stories do
      resources :comments
    end
  end

  root to: "projects#index"

end
