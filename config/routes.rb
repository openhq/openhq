require 'route_constraints/root_domain'
require 'route_constraints/subdomain'
require 'route_constraints/single_site'
require 'route_constraints/multi_site'
require 'route_constraints/non_api'

Rails.application.routes.draw do

  apipie

  # Clearance routes for authentication
  resources :passwords,
    controller: 'reset_passwords',
    only: [:create, :new]

  resource :session,
    controller: 'clearance/sessions',
    only: [:create]

  resources :users,
    controller: 'clearance/users',
    only: Clearance.configuration.user_actions do
      resource :password,
        controller: 'clearance/passwords',
        only: [:create, :edit, :update]
    end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  # end Clearance routes

  constraints(RouteConstraints::RootDomain) do
    resources :signups, only: [:new, :create] do
      get "success", on: :collection
    end
  end # root domain constraint

  constraints(RouteConstraints::Subdomain) do
    # First time setup flow
    constraints(RouteConstraints::SingleSite) do
      get "/setup", to: "setup/single_site#index", as: :setup_first_time_user
      post "/setup", to: "setup/single_site#create", as: :setup_create_first_user
    end
    constraints(RouteConstraints::MultiSite) do
      get "/setup/start/:code", to: "setup/multisite#index", as: :setup
      put "/setup/user", to: "setup/multisite#update_user", as: :setup_user
    end
    get "/setup/first_project", to: "setup#first_project", as: :setup_first_project
    post "/setup/first_project", to: "setup#create_project"
    get "/setup/invite_team", to: "setup#invite_team", as: :setup_invite_team
    post "/setup/invite_team", to: "setup#send_invites"

    resources :team_invites, only: [:edit, :update]
  end # subdomain constraint

  namespace :api, format: "json" do
    resources :user, only: :index
    resources :notification, only: :show

    namespace :v1 do
      resources :auth, only: [:create]
      resource :user, except: [:new, :edit], controller: :user
      resources :users, only: :index
      resources :team_invites, only: [:index, :create, :update]
      resources :projects, except: [:new, :edit] do
        put "restore", on: :member
      end
      resources :stories, except: [:new, :edit] do
        get "collaborators", on: :member
        put "restore", on: :member
      end
      resources :comments, except: [:new, :edit]
      resources :tasks, except: [:new, :edit] do
        get "me", on: :collection
        put "order", on: :collection, to: "tasks#update_order"
        delete "completed", on: :collection, to: "tasks#destroy_completed"
      end
      resources :attachments, except: [:new, :edit] do
        get "presigned_upload_url", on: :collection
      end
      resources :notifications, only: [:index, :show] do
        get "unseen", on: :collection
        put "mark_all_seen", on: :collection
        put "mark_as_seen", on: :collection
      end
      resources :search, only: [:index]
      get "/mentions/users" => "mentions#users"
      get "/mentions/emojis" => "mentions#emojis"
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Dynamic error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  get "help", to: "public#help"

  root to: "angular#index"

  match "*path", to: "angular#index", via: :all, constraints: RouteConstraints::NonApi

end
