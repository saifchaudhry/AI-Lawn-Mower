class Shop < ApplicationRecord
  belongs_to :location
  has_many :shop_services, dependent: :destroy
  has_many :services, through: :shop_services
  has_many :shop_brands, dependent: :destroy
  has_many :brands, through: :shop_brands
  has_many :reviews, dependent: :destroy
  has_many :shop_images, -> { order(position: :asc) }, dependent: :destroy
  # has_one_attached :logo

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }

  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  scope :verified, -> { where(verified: true) }
  scope :open_now, -> {
    current_time = Time.current.strftime("%H:%M:%S")
    where("open_time <= ? AND close_time >= ?", current_time, current_time)
  }
  scope :by_distance, ->(lat, lng) { near([lat, lng], 50).order(:distance) }
  scope :by_rating, -> { order(rating: :desc) }

  validates :name, :address, :city, :state, presence: true

  def full_address
    [address, city, state, zip].compact.join(', ')
  end

  def open?
    return false unless open_time && close_time
    current = Time.current.strftime("%H:%M")
    current >= open_time.strftime("%H:%M") && current <= close_time.strftime("%H:%M")
  end

  def blade_sharpen_range
    "$#{blade_sharpen_min.to_i} - $#{blade_sharpen_max.to_i}"
  end

  def tune_up_range
    "$#{tune_up_min.to_i} - $#{tune_up_max.to_i}"
  end

  def primary_image
    shop_images.first&.image&.url || 'default-shop.jpg'
  end
end
