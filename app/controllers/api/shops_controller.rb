module Api
  class ShopsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      location = Location.find_by(slug: params[:location_slug])
      return render json: { error: 'Location not found' }, status: :not_found unless location

      shops = location.shops.includes(:services, :brands)

      render json: shops.map { |shop|
        {
          id: shop.id,
          name: shop.name,
          latitude: shop.latitude,
          longitude: shop.longitude,
          rating: shop.rating,
          verified: shop.verified
        }
      }
    end

    def show
      shop = Shop.find(params[:id])
      render json: shop.as_json(
        include: [:services, :brands, :shop_images],
        methods: [:blade_sharpen_range, :tune_up_range, :open?, :primary_image]
      )
    end
  end
end
