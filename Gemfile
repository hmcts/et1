#source 'https://rubygems.org'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.8'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.3'
gem 'responders', '~> 2.4'

# Azure deployment so we need this
gem 'azure_env_secrets', git: 'https://github.com/ministryofjustice/azure_env_secrets.git', tag: 'v0.1.3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.2'

# Use unicorn as the app server
gem 'unicorn', '~> 5.5'

# Use null db adapter for the form objects
gem 'activerecord-nulldb-adapter', '~> 0.3'

# Enables communication with API for direct upload
gem 'et_dropzone_uploader', git: 'https://github.com/hmcts/et_dropzone_uploader.git', tag: 'v2.2.0'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

group :development, :test do
  gem 'awesome_print', '~> 1.8'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8'
  gem 'capybara', '~> 3.16'
  gem 'codeclimate-test-reporter', '~> 0.4', require: nil
  gem 'dotenv-rails', '~> 2.7'
  gem 'factory_bot_rails', '~> 5.0'
  gem 'guard-livereload', '~> 2.5'
  gem 'launchy'
  gem 'pry-rails', '~> 0.3'
  gem 'rack-livereload', '~> 0.3'
  gem 'rspec-its', '~> 1.2', require: 'rspec/its'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '~> 0.70', :require => false
  gem 'rubocop-rspec', '~> 1.32', :require => false
  gem 'shoulda-matchers', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'parallel_tests', '~> 2.28'
  gem 'parallel_tests', '~> 2.28'
end

group :test do
  gem 'webmock', '~> 3.5'
  gem 'database_cleaner', '~> 1.7'
  gem 'cucumber-rails', '~> 1.7', require: false
  gem 'poltergeist', '~> 1.18'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'site_prism', '~> 3.0'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'climate_control', '~> 0.2'
  gem 'webdrivers', '~> 3.7'
  gem 'azure-storage', '~> 0.15.0.preview'
end

group :production, :local do
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '~> 4.1'
end

group :production do
  # Only use bootsnap in prod to prevent debugging issues
  gem 'bootsnap', '~> 1.4'
end

group :production, :test do
  gem 'sentry-raven', '~> 2.9'
end

gem 'activeadmin', '~> 1.3'
gem 'base32_pure', '~> 0.1'
gem 'bcrypt', '~> 3.1'
gem 'bitmask_attributes', '~> 1.0'


gem 'browserify-rails', '~> 4.3'
gem 'carrierwave', '~> 1.2'
gem 'fog-aws', '~> 3.0'
gem 'govuk_frontend_toolkit', '~> 4.0.0'
gem 'moj_template', '0.23.0'
gem 'pdf-forms', '~> 1.2'
gem 'pg', '~> 1.1'
gem 'redcarpet', '3.4'
gem 'simple_form', '~> 4.0'
gem 'slim-rails', '~> 3.2'
gem 'sidekiq', '~> 5.2'
gem 'sidekiq-failures', '~> 1.0'
gem 'sidekiq_alive', '~> 1.1'
gem 'uk_postcode', '~> 2.1'
gem 'susy', '~> 2.2'
gem 'zendesk_api', '~> 1.5.1x'
gem 'email_validator', '~> 1.6'
gem 'typhoeus', '~> 1.3', '>= 1.3.1'

# This gem ensures rails 4 also builds a non-digest version of the assets
# so that static pages can refer to them.
gem "non-stupid-digest-assets", '~> 1.0'
