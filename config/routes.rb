Rails.application.routes.draw do

  devise_for :users

  resources :projects

  root to: "projects#index"

end
