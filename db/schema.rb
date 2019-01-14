# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140527154731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: true do |t|
    t.string   "first_name",      default: "",    null: false
    t.string   "last_name",       default: "",    null: false
    t.string   "role",                            null: false
    t.string   "email",                           null: false
    t.boolean  "status",          default: false
    t.string   "token",                           null: false
    t.string   "password_digest",                 null: false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "establishment_categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grouporder"
    t.integer  "sort_order"
  end

  create_table "establishment_categories_establishments", force: true do |t|
    t.integer  "establishment_id"
    t.integer  "establishment_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "establishment_category_establishments", force: true do |t|
    t.integer  "establishment_id"
    t.integer  "establishment_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "establishment_establishment_categories", force: true do |t|
    t.integer  "establishment_id"
    t.integer  "establishment_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "establishments", force: true do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "phone"
    t.string   "website"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "youtube_url"
    t.string   "logo_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.boolean  "featured",      default: false
    t.float    "distance"
    t.text     "featured_text"
  end

  create_table "events", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "establishment_id"
    t.string   "title"
    t.text     "description"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specials", force: true do |t|
    t.string   "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recurring"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
