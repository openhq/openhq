# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'openhq.io'
set :repo_url, 'git@github.com:openhq/openhq.git'
set :deploy_to, '/var/www/app.openhq.io'
set :log_level, :info
set :linked_files, %w(.env)
set :linked_dirs, %w(log tmp/uploads)
set :migration_role, :app
set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'
set :keep_releases, 3
set :passenger_restart_with_sudo, true
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :rails do
  desc 'Open the rails console on the primary remote server'
  task :console do
    on roles(:app), primary: true do |host|
      command = "cd #{deploy_to}/current && /home/#{host.user}/.rbenv/shims/bundle exec rails console #{fetch(:stage)}"
      exec "ssh -l #{host.user} #{host.hostname} -p #{host.port || 22} -t 'cd #{deploy_to}/current && #{command}'"
    end
  end
end




# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
