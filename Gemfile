source 'https://rubygems.org'

ruby '2.2.0'

# New mime-types uses way less memory
gem 'mime-types', '~> 2.6.1', require: 'mime/types/columnar'

gem 'rails', '~> 4.2.0'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'

# Load environment variables
gem 'dotenv-rails', '~> 1.0.2'

# Error tracking
gem "sentry-raven", git: "https://github.com/getsentry/raven-ruby.git", require: 'raven'

# User authentication/authorization
gem 'devise'
gem 'cancancan', '~> 1.10'

# Form helpers
gem 'simple_form'

# Slugs in urls
gem 'friendly_id', '~> 5.0.4'

# File uploads
gem 'aws-sdk', '~> 1.6'
gem 'paperclip', '~> 4.2.0'

# Markdown / editing support
gem 'html-pipeline'
gem 'github-markdown'
gem 'sanitize', '~> 3.0.3'
gem 'rinku'
gem 'gemoji', '~> 2.1.0'

# Pagination
gem 'kaminari', '~> 0.16.1'

# Sending emails
gem 'mailgun_rails'
gem 'roadie-rails', '~> 1.0.4'

# Background jobs
gem 'sucker_punch', '~> 1.2.1'

gem 'puma'

group :development, :test do
  gem 'spring'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :development do
  gem 'quiet_assets'
  gem 'letter_opener_web'
end

group :test do
  gem 'minitest-rails'
  gem 'minitest-rg'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'mocha'
end

group :production do
  gem 'rails_12factor'
end
