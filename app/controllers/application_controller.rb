class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_current_location

  private

  def set_current_location
    if params[:location_slug]
      @current_location = Location.find_by(slug: params[:location_slug])
    elsif cookies[:user_location]
      @current_location = Location.find_by(id: cookies[:user_location])
    end
  end
end
