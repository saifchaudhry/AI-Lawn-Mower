# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_01_19_142126) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "state", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "state"], name: "index_locations_on_name_and_state"
    t.index ["slug"], name: "index_locations_on_slug", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["shop_id"], name: "index_reviews_on_shop_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_services_on_slug", unique: true
  end

  create_table "shop_brands", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_shop_brands_on_brand_id"
    t.index ["shop_id", "brand_id"], name: "index_shop_brands_on_shop_id_and_brand_id", unique: true
    t.index ["shop_id"], name: "index_shop_brands_on_shop_id"
  end

  create_table "shop_images", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_images_on_shop_id"
  end

  create_table "shop_services", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_shop_services_on_service_id"
    t.index ["shop_id", "service_id"], name: "index_shop_services_on_shop_id_and_service_id", unique: true
    t.index ["shop_id"], name: "index_shop_services_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.decimal "rating", precision: 2, scale: 1, default: "0.0"
    t.integer "reviews_count", default: 0
    t.boolean "verified", default: false
    t.time "open_time"
    t.time "close_time"
    t.decimal "blade_sharpen_min", precision: 8, scale: 2
    t.decimal "blade_sharpen_max", precision: 8, scale: 2
    t.decimal "tune_up_min", precision: 8, scale: 2
    t.decimal "tune_up_max", precision: 8, scale: 2
    t.string "turnaround"
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_shops_on_latitude_and_longitude"
    t.index ["location_id"], name: "index_shops_on_location_id"
    t.index ["rating"], name: "index_shops_on_rating"
    t.index ["verified"], name: "index_shops_on_verified"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reviews", "shops"
  add_foreign_key "reviews", "users"
  add_foreign_key "shop_brands", "brands"
  add_foreign_key "shop_brands", "shops"
  add_foreign_key "shop_images", "shops"
  add_foreign_key "shop_services", "services"
  add_foreign_key "shop_services", "shops"
  add_foreign_key "shops", "locations"
end
