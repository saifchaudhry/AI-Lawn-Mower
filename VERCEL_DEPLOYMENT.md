# Vercel Deployment Guide

## Overview
This Rails application is configured for deployment on Vercel using the Ruby runtime.

## Prerequisites
- Vercel account
- Ruby 3.2.2
- Bundler 2.4.10
- PostgreSQL database (recommend using a managed service like Supabase, Railway, or Neon)

## Environment Variables

Configure these environment variables in your Vercel project settings:

### Required Variables
```
RAILS_ENV=production
RACK_ENV=production
SECRET_KEY_BASE=<your-secret-key-base>
DATABASE_URL=<your-postgresql-connection-string>
```

### Optional Variables
```
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
RUN_MIGRATIONS=true
```

### Generating SECRET_KEY_BASE
Run locally:
```bash
rails secret
```

## Deployment Steps

1. **Connect your repository to Vercel**
   - Go to Vercel dashboard
   - Import your Git repository
   - Select the project

2. **Configure Build Settings**
   - Framework Preset: Other
   - Build Command: `bash vercel-build.sh`
   - Output Directory: `public`
   - Install Command: `echo 'Dependencies installed in buildCommand'`

3. **Set Environment Variables**
   - Add all required environment variables in Vercel project settings
   - Ensure DATABASE_URL points to your production database

4. **Deploy**
   - Push to your main branch or trigger manual deployment
   - Monitor build logs for any errors

## Files Configuration

### vercel.json
- Defines build configuration and routes
- Specifies Ruby 3.2 runtime
- Configures asset serving and Rails routing

### vercel-build.sh
- Custom build script that:
  - Installs bundler 2.4.10
  - Installs Ruby dependencies
  - Precompiles assets
  - Optionally runs migrations

### package.json
- Contains npm dependencies for TailwindCSS and esbuild
- Defines build scripts

## Troubleshooting

### Psych Gem Native Extension Error
If you encounter errors about `psych` gem failing to build with "yaml.h not found":

**Solution 1: Use psych constraint (Already configured)**
The Gemfile now includes `gem "psych", "< 5.3"` which uses a version without native extension issues.

**Solution 2: If still failing, add to your Gemfile:**
```ruby
# Force psych to use a specific compatible version
gem "psych", "~> 5.1.2"
```

Then run locally:
```bash
bundle lock --add-platform x86_64-linux
bundle lock --add-platform arm64-linux
```

**Root Cause:**
Vercel's Ruby runtime may use Ruby 3.3.0 instead of 3.2.2, and psych 5.3+ requires libyaml-dev headers which aren't available in the serverless environment.

### Bundler Version Issues
The project uses bundler 2.4.10 specifically. The build script ensures this version is installed.

### Asset Precompilation Failures
- Ensure all frontend dependencies are installed
- Check that DATABASE_URL is set (Rails requires it for asset precompilation)
- Verify SECRET_KEY_BASE is configured

### Database Connection Issues
- Verify DATABASE_URL format: `postgresql://user:password@host:port/database`
- Ensure database server allows connections from Vercel IPs
- Check database credentials

### Migration Failures
- Set `RUN_MIGRATIONS=false` if you manage migrations separately
- Run migrations manually using Vercel CLI: `vercel env pull && rails db:migrate`

## Database Setup

For production database, consider these options:

1. **Supabase** (Recommended)
   - Free tier available
   - PostgreSQL compatible
   - Built-in auth and APIs

2. **Railway**
   - Simple PostgreSQL deployment
   - Good free tier

3. **Neon**
   - Serverless PostgreSQL
   - Generous free tier

## Monitoring

- Check Vercel deployment logs for build errors
- Monitor Rails logs in Vercel function logs
- Set up error tracking (e.g., Sentry, Rollbar)

## Local Testing

Test the build process locally:
```bash
bash vercel-build.sh
```

## Additional Notes

- Static assets are served from `/public/assets/`
- The application uses TailwindCSS for styling
- Stimulus and Turbo are included for frontend interactivity
