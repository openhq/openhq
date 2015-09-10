require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OpenHq
  class Application < Rails::Application
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # Set Active::Job backend
    config.active_job.queue_adapter = :sidekiq

    config.active_record.schema_format = :sql

    config.active_record.raise_in_transactional_callbacks = true

    # Reloading of lib classes with require_dependency
    config.watchable_dirs['lib'] = [:rb]

    config.generators do |g|
      g.test_framework :rspec
      g.skip_routes true
      g.controller_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
    end

    config.to_prepare do
      Clearance::PasswordsController.layout 'auth'
      Clearance::SessionsController.layout 'auth'
    end
  end
end
