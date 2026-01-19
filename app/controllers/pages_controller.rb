class PagesController < ApplicationController
  def home
    @popular_locations = Location.joins(:shops)
                                 .group('locations.id')
                                 .order('COUNT(shops.id) DESC')
                                 .limit(12)
    @services = Service.all
    @shops_count = Shop.count
    @featured_shops = Shop.includes(:brands, :services, :location)
                          .order(rating: :desc)
                          .limit(5)
    @recent_reviews = Review.includes(:user, :shop)
                            .order(created_at: :desc)
                            .limit(5)
    @average_rating = Review.average(:rating)&.round(1) || 0
    @total_reviews = Review.count
    @lawn_care_providers = [
      { name: "Green Lawn Care", rating: 4.8, reviews: 105 },
      { name: "Perfect Yard Services", rating: 4.8, reviews: 98 },
      { name: "Pro Mow Denver", rating: 4.9, reviews: 87 },
      { name: "Quick Cut Lawns", rating: 4.7, reviews: 124 }
    ]
  end

  def join_pro
  end

  def get_quotes
  end
end
