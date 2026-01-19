class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.text :description
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip
      t.string :phone
      t.string :email
      t.string :website
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :rating, precision: 2, scale: 1, default: 0
      t.integer :reviews_count, default: 0
      t.boolean :verified, default: false
      t.time :open_time
      t.time :close_time
      t.decimal :blade_sharpen_min, precision: 8, scale: 2
      t.decimal :blade_sharpen_max, precision: 8, scale: 2
      t.decimal :tune_up_min, precision: 8, scale: 2
      t.decimal :tune_up_max, precision: 8, scale: 2
      t.string :turnaround
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end

    add_index :shops, :verified
    add_index :shops, :rating
    add_index :shops, [:latitude, :longitude]
  end
end
