class ShopsController < ApplicationController
  before_action :set_location
  before_action :set_shop, only: [:show]

  def index
    @shops = @location.shops.includes(:services, :brands, :shop_images)

    # Apply search
    @shops = @shops.search_by_name(params[:q]) if params[:q].present?

    # Apply sorting
    @shops = case params[:sort]
             when 'distance'
               @shops.by_distance(@location.latitude, @location.longitude)
             when 'rating'
               @shops.by_rating
             when 'price_low'
               @shops.order(tune_up_min: :asc)
             else
               @shops.by_rating
             end

    # Apply filters
    @shops = @shops.verified if params[:verified] == 'true'
    @shops = @shops.joins(:services).where(services: { slug: params[:service] }) if params[:service].present?

    @pagy, @shops = pagy(@shops, items: 10)
    @shops_count = @location.shops.count

    respond_to do |format|
      format.html
      format.json { render json: @shops.as_json(include: [:services, :brands]) }
    end
  end

  def show
    @similar_shops = @location.shops.where.not(id: @shop.id).limit(4)
  end

  private

  def set_location
    @location = Location.find_by!(slug: params[:location_slug])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Location not found"
  end

  def set_shop
    @shop = @location.shops.find(params[:id])
  end
end
