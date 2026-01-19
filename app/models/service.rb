class Service < ApplicationRecord
  has_many :shop_services, dependent: :destroy
  has_many :shops, through: :shop_services

  validates :name, presence: true, uniqueness: true

  before_validation :generate_slug

  private

  def generate_slug
    self.slug ||= name.parameterize
  end
end
