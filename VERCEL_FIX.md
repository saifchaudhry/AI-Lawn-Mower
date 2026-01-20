# Quick Fix for Vercel Psych Error

## The Error
```
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
checking for yaml.h... no
yaml.h not found
```

## The Fix (Applied)

### 1. Ruby Version Pinned ✅
**Gemfile** now includes:
```ruby
ruby "3.2.2"
gem "psych", "< 5.3"  # Avoid native extension issues
```

### 2. Gemfile.lock Updated ✅
Added Ruby version constraint and psych dependency.

### 3. Vercel Configuration Updated ✅
**vercel.json** now specifies:
- Ruby 3.2 runtime
- Custom build command
- Proper environment variables

### 4. Build Script Enhanced ✅
**vercel-build.sh** now:
- Explicitly installs bundler 2.4.10
- Configures bundle for production
- Handles asset precompilation correctly

## What You Need to Do

### 1. Commit These Changes
```bash
git add .
git commit -m "Fix Vercel deployment - pin Ruby 3.2.2 and psych < 5.3"
git push
```

### 2. Configure Vercel Environment Variables
In your Vercel project settings, add:

```bash
SECRET_KEY_BASE=<run 'rails secret' locally and paste here>
DATABASE_URL=postgresql://postgres.vencmprsngsjxfkdxzjv:3H3RxaVpgMf8X9Vp@aws-1-eu-west-1.pooler.supabase.com:5432/postgres
RAILS_ENV=production
RACK_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### 3. Deploy
Push to your repository or trigger a manual deploy in Vercel.

## If You Still Get Errors

### Option A: Try psych 5.1.2 specifically
Edit **Gemfile**:
```ruby
gem "psych", "~> 5.1.2"
```

Then run locally:
```bash
bundle lock --add-platform x86_64-linux
git add Gemfile.lock
git commit -m "Lock platforms for Vercel"
git push
```

### Option B: Use older Vercel Ruby buildpack
Edit **vercel.json**:
```json
"builds": [
  {
    "src": "bin/rails",
    "use": "@vercel/ruby@3.0.0",
    "config": {
      "runtime": "ruby3.2"
    }
  }
]
```

## Why This Happens

1. **Ruby Version Mismatch**: Vercel might use Ruby 3.3.0 when you need 3.2.2
2. **Psych 5.3+**: Requires `libyaml-dev` system headers which aren't in Vercel's serverless environment
3. **Native Extensions**: Can't compile C extensions in Vercel's restricted build environment

## Verification

Once deployed, check:
1. Build logs show Ruby 3.2.2
2. Bundle install succeeds without gem compilation errors
3. Assets precompile successfully
4. App starts without errors

## Support

If issues persist, check:
- Vercel build logs for specific errors
- Ruby version in logs: should show "3.2.2"
- psych version in logs: should be < 5.3
