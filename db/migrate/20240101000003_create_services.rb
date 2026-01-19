class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :services, :slug, unique: true
  end
end
