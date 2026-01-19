class CreateShopBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_brands do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end

    add_index :shop_brands, [:shop_id, :brand_id], unique: true
  end
end
