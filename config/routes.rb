Rails.application.routes.draw do

  devise_for :users

  resources :projects do
    resources :stories
  end

  root to: "projects#index"

end
