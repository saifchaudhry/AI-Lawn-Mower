class Brand < ApplicationRecord
  has_many :shop_brands, dependent: :destroy
  has_many :shops, through: :shop_brands

  validates :name, presence: true, uniqueness: true
end
