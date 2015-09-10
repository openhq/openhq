require 'route_constraints/root_domain'
require 'route_constraints/subdomain'
require 'sidekiq/web'

Rails.application.routes.draw do

  constraints(RouteConstraints::RootDomain) do
    resources :signups, only: [:new, :create]
  end # root domain constrain

  constraints(RouteConstraints::Subdomain) do
    get "/" => "projects#index"

    # First time setup
    get '/setup' => 'setup#new'
    post '/setup' => 'setup#create'
    get '/setup/complete' => 'setup#initial_setup', as: :initial_setup
    post '/setup/complete' => 'setup#complete'

    resource :account, only: [:edit, :update, :destroy], controller: :account

    resources :files, only: :index
    resources :team, only: [:index, :show]
    resources :team_invites, only: [:new, :create, :edit, :update]
    resources :search, only: :index

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

  end # subdomain constraint

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Dynamic error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  root to: "public#index"

end
