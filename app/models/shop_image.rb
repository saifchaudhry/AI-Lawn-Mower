class ShopImage < ApplicationRecord
  belongs_to :shop
  has_one_attached :image

  validates :image, presence: true

  default_scope { order(position: :asc) }
end
