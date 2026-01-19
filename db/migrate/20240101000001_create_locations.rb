class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :slug, null: false

      t.timestamps
    end

    add_index :locations, :slug, unique: true
    add_index :locations, [:name, :state]
  end
end
