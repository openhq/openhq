source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'pg'

# Load environment variables
gem 'dotenv-rails', '~> 1.0.2'

# Error tracking
gem "sentry-raven", git: "https://github.com/getsentry/raven-ruby.git", require: 'raven'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'

# User authentication
gem 'devise'

# Form helpers
gem 'simple_form'

# Slugs in urls
# gem 'friendly_id', '~> 5.0.4'

# Admin area
# gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin'

# File uploads
# gem 'paperclip', '~> 4.2.0'
# gem 'aws-sdk', '~> 1.5.7'

# Sanitize user generated html output
# gem 'sanitize', '~> 3.0.3'

# Pagination
gem 'kaminari', '~> 0.16.1'

# Sending emails
gem 'postmark-rails', '~> 0.8.0'
gem 'roadie-rails', '~> 1.0.4'

# Background jobs
# gem 'sucker_punch', '~> 1.2.1'

##
# API helpers
# gem 'active_model_serializers', '~> 0.9.2'
# gem 'swagger-ui_rails'
# gem 'swagger-docs'
# gem 'rest-client', '~> 1.7.2'
# gem 'multi_json'

group :development do
  gem 'spring'

  # Stops assets from being logged
  gem 'quiet_assets'

  # Catch sent emails
  gem 'letter_opener_web'

  # Use capistrano if deploying to your own servers
  # gem 'capistrano',  '~> 3.1'
  # gem 'capistrano-rails', '~> 1.1'
  # gem 'capistrano-rbenv', '~> 2.0'
end

group :test do
  gem 'minitest-rails'
  gem 'minitest-rg'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'mocha'
end