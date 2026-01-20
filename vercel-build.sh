#!/usr/bin/env bash
set -e

echo "Starting Vercel build process..."

# Display Ruby version
echo "Ruby version: $(ruby -v)"

# Install bundler 2.4.10 specifically
echo "Installing bundler 2.4.10..."
gem install bundler -v 2.4.10 --no-document

# Set bundler config for Vercel environment
echo "Configuring bundler..."
bundle config set --local deployment 'false'
bundle config set --local path 'vendor/bundle'
bundle config set --local without 'development:test'
bundle config set --local jobs 1

# Install dependencies
echo "Installing Ruby dependencies..."
bundle _2.4.10_ install --retry 3

# Precompile assets
echo "Precompiling assets..."
SECRET_KEY_BASE="${SECRET_KEY_BASE:-$(bundle exec rails secret)}" \
DATABASE_URL="${DATABASE_URL}" \
RAILS_ENV=production \
bundle exec rails assets:precompile

# Run migrations (if needed)
if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "Running migrations..."
  bundle exec rails db:migrate
fi

echo "Build completed successfully!"
