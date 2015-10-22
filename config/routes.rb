require 'route_constraints/root_domain'
require 'route_constraints/subdomain'
require 'route_constraints/single_site'
require 'route_constraints/multi_site'
require 'sidekiq/web'

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

    get "/settings", to: redirect('/settings/account/edit'), as: :settings
    namespace :settings do
      resource :password, only: [:show, :create]
      resource :account, only: [:edit, :update, :destroy], controller: :account do
        get "delete"
      end
      resources :teams, only: [:show, :new, :create, :update] do
        delete "leave", on: :member
      end
    end
  end # root domain constraint

  constraints(RouteConstraints::Subdomain) do
    get "/" => "projects#index"

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

    resources :files, only: :index
    resources :team, only: [:index, :show, :update, :destroy]
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
          delete "delete-completed", on: :collection
        end
        resources :attachments
      end
    end

    resources :me, only: :index

    resources :notifications, only: [:index] do
      put "mark_all_seen", on: :collection
    end

  end # subdomain constraint

  namespace :api, format: "json" do
    resources :user, only: :index
    resources :notification, only: :show

    namespace :v1 do
      resources :auth, only: [:create]
      resource :user, except: [:new, :edit], controller: :user
      resources :team_invites, except: [:new, :edit]

      resources :projects, except: [:new, :edit] do
        resources :stories, except: [:new, :edit] do
          resources :comments, except: [:new, :edit]
          resources :tasks, except: [:new, :edit] do
            put "order", on: :collection, to: "tasks#update_order"
            delete "completed", on: :collection, to: "tasks#destroy_completed"
          end
          resources :attachments, except: [:new, :edit] do
            get "presigned_upload_url", on: :collection
          end
        end
      end
    end
  end

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
  get "help", to: "public#help"

end
