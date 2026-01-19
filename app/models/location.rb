class Location < ApplicationRecord
  has_many :shops, dependent: :destroy

  validates :name, :state, presence: true
  validates :slug, uniqueness: true

  before_validation :generate_slug

  geocoded_by :full_name
  after_validation :geocode, if: :name_changed?

  def full_name
    "#{name}, #{state}"
  end

  def shops_count
    shops.count
  end

  private

  def generate_slug
    self.slug ||= "#{name}-#{state}".parameterize
  end
end
