class LocationsController < ApplicationController
  def index
    @locations = Location.includes(:shops).order(:state, :name)
    @locations_by_state = @locations.group_by(&:state)
  end

  def show
    @location = Location.find_by!(slug: params[:slug])
    redirect_to location_shops_path(location_slug: @location.slug)
  end
end
