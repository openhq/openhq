source 'https://rubygems.org'

ruby '2.2.2'

# New mime-types uses way less memory
gem 'mime-types', '~> 2.6.1', require: 'mime/types/columnar'

gem 'rails', '~> 4.2.3'
gem 'pg'
gem 'pg_search'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem "autoprefixer-rails"

# Multitennate subdomains
gem 'acts_as_tenant'

# Load environment variables
gem 'dotenv-rails', '~> 1.0.2'

# Error tracking
gem "sentry-raven", git: "https://github.com/getsentry/raven-ruby.git", require: 'raven'

# User authentication/authorization
gem 'clearance'
gem 'cancancan', '~> 1.10'

# Serializers
gem 'active_model_serializers', '~> 0.9.3'

# Form helpers
gem 'simple_form'

# Slugs in urls
gem 'friendly_id', '~> 5.0.4'

# File uploads
gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '< 2.0'
gem 's3_direct_upload', '~> 0.1.7'

# Background jobs
gem 'sinatra', require: nil # for sidekiq/web
gem 'sidekiq'

# Markdown / editing support
gem 'html-pipeline'
gem 'github-markdown'
gem 'sanitize', '~> 3.0.3'
gem 'rinku'
gem 'gemoji', '~> 2.1.0'
gem 'jquery-atwho-rails' # @mention autocomplete

# Imagemagick for image manipulation
gem 'rmagick'

# Pagination
gem 'kaminari', '~> 0.16.1'

# Soft deletes
gem "paranoia", "~> 2.0"

# Sending emails
gem 'mailgun_rails'
gem 'roadie-rails', '~> 1.0.4'

gem 'puma'

group :development, :test do
  gem 'spring'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  gem 'rubocop', require: false
end

group :development do
  gem 'rack-mini-profiler'
  gem 'quiet_assets'
  gem 'letter_opener_web'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara', '~> 2.0'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', require: false
  gem 'faker'
  gem 'database_cleaner'
  gem 'mocha'
  gem 'coveralls', require: false
end

group :production do
  gem 'rails_12factor'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-highlightjs'
end
