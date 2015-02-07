require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectManagementApp
  class Application < Rails::Application
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    config.active_job.queue_adapter = :sucker_punch

    config.generators do |g|
      g.test_framework :minitest, spec: true, fixture: false
      g.skip_routes true
      g.controller_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
    end

    # Custom sign-in layout
    config.to_prepare do
      Devise::SessionsController.layout "auth"
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "auth" }
      Devise::ConfirmationsController.layout "auth"
      Devise::UnlocksController.layout "auth"
      Devise::PasswordsController.layout "auth"
    end
  end
end
