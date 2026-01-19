class CreateShopImages < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_images do |t|
      t.references :shop, null: false, foreign_key: true
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
