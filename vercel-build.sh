#!/usr/bin/env bash
set -e

echo "Starting Vercel build process..."

# Install bundler 2.4.10 specifically
echo "Installing bundler 2.4.10..."
gem install bundler -v 2.4.10

# Install dependencies
echo "Installing Ruby dependencies..."
bundle _2.4.10_ install --jobs 1 --retry 3

# Precompile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile

# Run migrations (if needed)
if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "Running migrations..."
  bundle exec rails db:migrate
fi

echo "Build completed successfully!"
