class CreateShopServices < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_services do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end

    add_index :shop_services, [:shop_id, :service_id], unique: true
  end
end
