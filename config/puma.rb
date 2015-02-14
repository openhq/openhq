workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['MIN_PUMA_THREADS']  || 8), Integer(ENV['MAX_PUMA_THREADS'] || 8)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

quiet # don’t log requests, rails does this for us

on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['DB_POOL'] || ENV['MAX_PUMA_THREADS'] || 5
    ActiveRecord::Base.establish_connection(config)
  end
end
