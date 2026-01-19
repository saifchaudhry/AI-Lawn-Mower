# GreenPal - Lawn Mower Repair Shop Finder

A Ruby on Rails application for finding lawn mower repair shops in your area. Browse shops by location, compare services and pricing, read reviews, and get quotes from verified professionals.

## Table of Contents

- [Requirements](#requirements)
- [Local Setup](#local-setup)
- [Database Models](#database-models)
- [Frontend Structure](#frontend-structure)
- [CSS & Styling](#css--styling)
- [Features](#features)

---

## Requirements

- Ruby 3.2.2
- PostgreSQL 14+
- Node.js 18+
- Yarn (recommended) or npm

---

## Local Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd greenpal-test
```

### 2. Install Ruby Dependencies

```bash
bundle install
```

### 3. Install JavaScript Dependencies

```bash
yarn install
# or
npm install
```

### 4. Database Setup

Make sure PostgreSQL is running, then:

```bash
# Create the database
rails db:create

# Run migrations to create tables
rails db:migrate

# Seed the database with sample data
rails db:seed
```

### 5. Build CSS Assets

The project uses Tailwind CSS which needs to be compiled:

```bash
yarn build:css
```

### 6. Start the Development Server

```bash
bin/dev
```

This starts both the Rails server and the CSS watcher using Foreman. The app will be available at `http://localhost:3000`.

### Alternative: Start Services Separately

```bash
# Terminal 1: Rails server
rails server

# Terminal 2: CSS watcher (for live Tailwind updates)
yarn build:css --watch
```

### Environment Variables

No environment variables are required for basic local development. The app uses default PostgreSQL settings.

---

## Database Models

Models are located in `app/models/`. Here's an overview of each model and their relationships:

### Core Models

#### Shop (`app/models/shop.rb`)
The main model representing a lawn mower repair shop.

```ruby
# Associations
belongs_to :location
has_many :services, through: :shop_services
has_many :brands, through: :shop_brands
has_many :reviews
has_many :shop_images

# Key attributes
- name, address, city, state, zip
- phone, email
- latitude, longitude (geocoded)
- rating, reviews_count
- verified (boolean)
- open_time, close_time
- blade_sharpen_min/max, tune_up_min/max
- turnaround (e.g., "Same day", "1-2 days")

# Features
- Full-text search via pg_search
- Geocoding via geocoder gem
- Scopes: verified, open_now, by_distance, by_rating
```

#### Location (`app/models/location.rb`)
Represents a city/area where shops are located.

```ruby
has_many :shops

# Key attributes
- name (city name)
- state
- slug (URL-friendly identifier)
- latitude, longitude

# Auto-generates slug from name and state
```

#### Service (`app/models/service.rb`)
Types of repair services offered (e.g., "Blade Sharpening", "Engine Repair").

```ruby
has_many :shops, through: :shop_services

# Key attributes
- name
- slug
```

#### Brand (`app/models/brand.rb`)
Lawn mower brands that shops service (e.g., "Honda", "John Deere").

```ruby
has_many :shops, through: :shop_brands

# Key attributes
- name
```

#### Review (`app/models/review.rb`)
Customer reviews for shops.

```ruby
belongs_to :shop
belongs_to :user

# Key attributes
- rating (1-5)
- content

# Callbacks
- after_save/destroy: updates shop's average rating
```

#### User (`app/models/user.rb`)
User accounts managed by Devise.

```ruby
has_many :reviews
has_one :shop

# Authentication via Devise
- email, encrypted_password
- recoverable, rememberable, validatable
```

### Join Models

#### ShopService (`app/models/shop_service.rb`)
Joins shops and services (many-to-many).

#### ShopBrand (`app/models/shop_brand.rb`)
Joins shops and brands (many-to-many).

#### ShopImage (`app/models/shop_image.rb`)
Images for shops with position ordering.

### Creating New Models

To create a new model:

```bash
# Generate model with migration
rails generate model ModelName attribute:type attribute:type

# Run migration
rails db:migrate
```

Example:
```bash
rails generate model Coupon code:string discount:decimal shop:references expires_at:datetime
rails db:migrate
```

---

## Frontend Structure

### Views (`app/views/`)

```
app/views/
├── layouts/
│   └── application.html.erb    # Main layout with header, footer, sticky banner
├── pages/
│   └── home.html.erb           # Homepage with hero, shops, guides, etc.
├── shops/
│   ├── index.html.erb          # Shop listing page
│   └── show.html.erb           # Individual shop detail page
└── shared/
    ├── _header.html.erb        # Navigation header partial
    ├── _footer.html.erb        # Footer partial
    └── _shop_card.html.erb     # Reusable shop card component
```

### Key Pages

**Homepage (`pages/home.html.erb`)**
- Hero image section
- Featured shops listing with interactive map (Leaflet.js)
- Lawn mower repair guides carousel
- Lawn mowing services section
- "Why hire a professional" section
- Popular locations grid
- About section

**Shop Listing (`shops/index.html.erb`)**
- Filterable shop list
- Map integration
- Pagination via Pagy

**Shop Detail (`shops/show.html.erb`)**
- Full shop information
- Services and brands
- Reviews section
- Contact information

### JavaScript (`app/javascript/`)

The project uses Hotwire (Turbo + Stimulus) for interactivity:

- **Turbo**: Handles page navigation and form submissions without full page reloads
- **Stimulus**: Provides JavaScript controllers for interactive components

External libraries:
- **Leaflet.js**: Interactive maps (loaded via CDN)

---

## CSS & Styling

### Tailwind CSS Setup

The project uses **Tailwind CSS** via `cssbundling-rails`.

**Source file:** `app/assets/stylesheets/application.tailwind.css`

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Custom component styles (e.g., pagination) */
```

**Output file:** `app/assets/builds/application.css` (auto-generated)

### Tailwind Configuration

**File:** `tailwind.config.js`

```javascript
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        'greenpal': {
          'blue': '#0EA5E9',
          'orange': '#F97316',
          'green': '#22C55E',
          'dark-blue': '#0369A1'
        }
      }
    }
  },
  plugins: []
}
```

### Building CSS

```bash
# One-time build
yarn build:css

# Watch mode (rebuilds on file changes)
yarn build:css --watch

# Production build (minified)
yarn build:css --minify
```

### Custom Brand Colors

Use the custom GreenPal colors in your classes:

```html
<div class="bg-greenpal-blue text-white">Blue background</div>
<button class="bg-greenpal-orange">Orange button</button>
<span class="text-greenpal-green">Green text</span>
```

### Common Tailwind Patterns Used

**Cards:**
```html
<div class="bg-white rounded-lg shadow-sm border p-4">
```

**Buttons:**
```html
<button class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg font-semibold transition">
```

**Responsive Grid:**
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
```

**Flexbox Layout:**
```html
<div class="flex flex-col lg:flex-row gap-6">
```

---

## Features

- Search for repair shops by location
- Interactive map with shop locations (Leaflet.js)
- Reviews and ratings system
- Filter by services and brands
- User authentication (Devise)
- Verified shop badges
- Responsive design (mobile-friendly)
- Pagination (Pagy)
- Full-text search (pg_search)
- Geocoding (geocoder)

---

## Key Dependencies

### Ruby Gems
| Gem | Purpose |
|-----|---------|
| `rails 7.1` | Web framework |
| `pg` | PostgreSQL adapter |
| `devise` | User authentication |
| `geocoder` | Address geocoding |
| `pg_search` | Full-text search |
| `ransack` | Advanced searching/filtering |
| `pagy` | Pagination |
| `image_processing` | Image uploads |

### JavaScript Packages
| Package | Purpose |
|---------|---------|
| `@hotwired/turbo-rails` | SPA-like navigation |
| `@hotwired/stimulus` | JavaScript controllers |
| `tailwindcss` | Utility-first CSS |
| `esbuild` | JavaScript bundling |

---

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/shop_spec.rb
```

---

## Useful Commands

```bash
# Rails console
rails console

# Database console
rails dbconsole

# View all routes
rails routes

# Reset database (drop, create, migrate, seed)
rails db:reset

# Generate a new controller
rails generate controller ControllerName action1 action2

# Generate a new model
rails generate model ModelName field:type
```
