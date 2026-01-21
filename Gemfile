source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.0"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "psych", "< 5.3"

# Authentication
gem "devise", "~> 4.9"

# Search & Geocoding
gem "geocoder", "~> 1.8"
gem "pg_search", "~> 2.3"
gem "ransack", "~> 4.1"

# Pagination
gem "pagy", "~> 6.2"

# Image processing
gem "image_processing", "~> 1.12"
gem 'listen'

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
  gem "faker"
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "webrick"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
