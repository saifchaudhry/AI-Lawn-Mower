# Clear existing data
puts "Clearing existing data..."
ShopService.destroy_all
ShopBrand.destroy_all
Review.destroy_all
Shop.destroy_all
Location.destroy_all
Service.destroy_all
Brand.destroy_all
User.where.not(email: 'admin@example.com').destroy_all

# Create Services
puts "Creating services..."
services = [
  "Blade Sharpening",
  "Engine Repair",
  "Tune-Up",
  "Oil Change",
  "Carburetor Repair",
  "Starter Repair",
  "Belt Replacement",
  "Tire Replacement"
]

services.each do |name|
  Service.create!(name: name, slug: name.parameterize)
end

# Create Brands
puts "Creating brands..."
brands = [
  "Honda", "Toro", "John Deere", "Husqvarna", "Craftsman",
  "Troy-Bilt", "Briggs & Stratton", "Cub Cadet", "Snapper", "Ariens"
]

brands.each do |name|
  Brand.create!(name: name)
end

# Create Locations with Shops
puts "Creating locations and shops..."
locations_data = [
  { name: "Nashville", state: "TN", latitude: 36.1627, longitude: -86.7816 },
  { name: "Austin", state: "TX", latitude: 30.2672, longitude: -97.7431 },
  { name: "Atlanta", state: "GA", latitude: 33.7490, longitude: -84.3880 },
  { name: "Denver", state: "CO", latitude: 39.7392, longitude: -104.9903 },
  { name: "Phoenix", state: "AZ", latitude: 33.4484, longitude: -112.0740 },
  { name: "Charlotte", state: "NC", latitude: 35.2271, longitude: -80.8431 },
  { name: "Dallas", state: "TX", latitude: 32.7767, longitude: -96.7970 },
  { name: "Tampa", state: "FL", latitude: 27.9506, longitude: -82.4572 },
  { name: "Orlando", state: "FL", latitude: 28.5383, longitude: -81.3792 },
  { name: "Houston", state: "TX", latitude: 29.7604, longitude: -95.3698 },
  { name: "San Antonio", state: "TX", latitude: 29.4241, longitude: -98.4936 },
  { name: "Jacksonville", state: "FL", latitude: 30.3322, longitude: -81.6557 }
]

shop_names = [
  "Pro Mower Repair",
  "Quick Fix Small Engines",
  "Lawn Equipment Specialists",
  "The Mower Shop",
  "Green Thumb Repairs",
  "Precision Blade Services",
  "All-Star Engine Repair",
  "Neighborhood Mower Care"
]

all_services = Service.all.to_a
all_brands = Brand.all.to_a

locations_data.each do |loc_data|
  location = Location.create!(
    name: loc_data[:name],
    state: loc_data[:state],
    latitude: loc_data[:latitude],
    longitude: loc_data[:longitude]
  )

  # Create 2-5 shops per location
  rand(2..5).times do |i|
    shop = Shop.create!(
      name: "#{shop_names.sample} #{location.name}",
      description: "Professional lawn mower repair and maintenance services in #{location.full_name}. We service all major brands.",
      address: "#{rand(100..9999)} #{['Main St', 'Oak Ave', 'Elm Blvd', 'Park Dr', 'Industrial Way'].sample}",
      city: location.name,
      state: location.state,
      zip: rand(10000..99999).to_s,
      phone: "(#{rand(200..999)}) #{rand(200..999)}-#{rand(1000..9999)}",
      email: "info@mowerrepair#{rand(1000..9999)}.com",
      latitude: loc_data[:latitude] + rand(-0.05..0.05),
      longitude: loc_data[:longitude] + rand(-0.05..0.05),
      rating: rand(35..50) / 10.0,
      reviews_count: rand(5..100),
      verified: [true, false].sample,
      open_time: "08:00",
      close_time: "17:00",
      blade_sharpen_min: rand(10..20),
      blade_sharpen_max: rand(25..40),
      tune_up_min: rand(50..75),
      tune_up_max: rand(100..150),
      turnaround: ["Same day", "1-2 days", "2-3 days", "3-5 days"].sample,
      location: location
    )

    # Add random services to shop
    shop.services << all_services.sample(rand(3..6))

    # Add random brands to shop
    shop.brands << all_brands.sample(rand(3..7))
  end
end

# Create Users for Reviews
puts "Creating users..."
reviewer_names = [
  "John Smith", "Sarah Johnson", "Mike Wilson", "Emily Davis", "Chris Brown",
  "Jessica Martinez", "David Anderson", "Amanda Taylor", "Ryan Thomas", "Michelle Garcia",
  "Kevin Lee", "Lisa Robinson", "Jason White", "Nicole Harris", "Brandon Clark"
]

users = reviewer_names.map do |name|
  User.create!(
    email: "#{name.downcase.gsub(' ', '.')}@example.com",
    password: "password123"
  )
end

# Create Reviews
puts "Creating reviews..."
review_contents = [
  "Excellent service! They fixed my mower the same day I dropped it off. The blade sharpening was perfect and the engine runs like new. Highly recommend!",
  "Very professional and knowledgeable staff. They explained exactly what was wrong with my riding mower and gave me a fair quote. Will definitely come back.",
  "Great experience from start to finish. They picked up my mower, fixed it within 2 days, and delivered it back. The price was very reasonable.",
  "These guys know their stuff! My Honda mower wouldn't start and they diagnosed the carburetor issue quickly. Runs perfectly now.",
  "Fast turnaround and quality work. They replaced the belt on my self-propelled mower and now it works better than ever.",
  "Friendly service and fair prices. They were honest about what needed to be fixed vs what could wait. Appreciated the transparency.",
  "My go-to shop for all lawn equipment repairs. They've serviced my mower, edger, and leaf blower. Always reliable work.",
  "Brought in my old Craftsman mower thinking it was done for. They rebuilt the engine and it's running great. Saved me from buying a new one!",
  "Quick and efficient service. Dropped off for a tune-up in the morning, picked it up by afternoon. Mower starts on the first pull now.",
  "The team here really cares about their customers. They even showed me how to do basic maintenance to keep my mower running longer.",
  "Been coming here for years. Consistent quality and they stand behind their work. Recently had the deck welded and it's solid.",
  "Reasonable prices for blade sharpening. Much cheaper than the big box stores and way better quality. In and out in 30 minutes.",
  "They diagnosed an electrical issue that two other shops couldn't figure out. Fixed it right the first time. Very impressed!",
  "Outstanding customer service. They called with updates throughout the repair process. My Toro mower is back to peak performance.",
  "Finally found a reliable repair shop! They fixed my John Deere riding mower and it runs smoother than when I bought it."
]

Shop.all.each do |shop|
  # Create 3-8 reviews per shop
  rand(3..8).times do
    Review.create!(
      shop: shop,
      user: users.sample,
      rating: rand(4..5),
      content: review_contents.sample,
      created_at: rand(1..365).days.ago
    )
  end
end

puts "Seed data created successfully!"
puts "Created #{Location.count} locations"
puts "Created #{Shop.count} shops"
puts "Created #{Service.count} services"
puts "Created #{Brand.count} brands"
puts "Created #{User.count} users"
puts "Created #{Review.count} reviews"
