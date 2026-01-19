class Review < ApplicationRecord
  belongs_to :shop, counter_cache: true
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, presence: true, length: { minimum: 10 }

  after_save :update_shop_rating
  after_destroy :update_shop_rating

  private

  def update_shop_rating
    shop.update(rating: shop.reviews.average(:rating)&.round(1) || 0)
  end
end
