source 'https://rubygems.org'

ruby '2.2.2'

# New mime-types uses way less memory
gem 'mime-types', '~> 2.6.1', require: 'mime/types/columnar'

gem 'rails', '>= 5.0.0.rc1', '< 5.1'
gem 'pg'
gem 'pg_search'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'autoprefixer-rails' # scss prefixer
gem 'ejs'
gem 'angularjs-rails-resource', '~> 2.0.0'

# Multitennate subdomains
gem 'acts_as_tenant'

# Load environment variables
gem 'dotenv-rails', '~> 1.0.2'

# Error tracking
gem 'exception_notification'

# User authentication/authorization
gem 'clearance'
gem 'cancancan', '~> 1.10'

# Serializers
gem 'active_model_serializers', git: "https://github.com/rails-api/active_model_serializers.git", tag: 'v0.10.0.rc3'

# Form helpers
gem 'simple_form'

# Slugs in urls
gem 'friendly_id', '~> 5.0.4'

# File uploads
gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '< 2.0'

# Background jobs
gem 'sucker_punch'

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
gem "paranoia", git: "https://github.com/rubysherpas/paranoia.git", branch: "core"

# Sending emails
gem 'roadie-rails', '~> 1.1.1'

gem 'puma'
gem 'message_bus'

# API Docs
gem 'maruku'
gem 'apipie-rails'

group :development, :test do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rubocop', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
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
  gem 'vcr', require: false
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-highlightjs'
end
