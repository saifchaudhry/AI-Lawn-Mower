#!/usr/bin/env bash
set -e

echo "Running production migrations..."
echo "Database: $DATABASE_URL"

if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL environment variable is not set"
  echo "Set it with your Supabase connection string:"
  echo 'export DATABASE_URL="postgresql://postgres.vencmprsngsjxfkdxzjv:3H3RxaVpgMf8X9Vp@aws-1-eu-west-1.pooler.supabase.com:5432/postgres"'
  exit 1
fi

# Run migrations
RAILS_ENV=production bundle exec rails db:migrate

echo "✓ Migrations completed successfully!"

# Optional: Run seeds
read -p "Do you want to seed the database? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Seeding database..."
  RAILS_ENV=production bundle exec rails db:seed
  echo "✓ Database seeded successfully!"
fi

echo "Done!"
