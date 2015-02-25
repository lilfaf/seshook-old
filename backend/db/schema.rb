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

ActiveRecord::Schema.define(version: 20150225181131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "addresses", force: :cascade do |t|
    t.string   "country_code",     null: false
    t.string   "street",           null: false
    t.string   "city",             null: false
    t.string   "zip"
    t.string   "state"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree
  add_index "addresses", ["street", "city"], name: "index_addresses_on_street_and_city", using: :btree

  create_table "albums", force: :cascade do |t|
    t.string   "name",           null: false
    t.text     "description"
    t.integer  "albumable_id"
    t.string   "albumable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
  end

  add_index "albums", ["albumable_type", "albumable_id"], name: "index_albums_on_albumable_type_and_albumable_id", using: :btree
  add_index "albums", ["name"], name: "index_albums_on_name", using: :btree
  add_index "albums", ["user_id"], name: "index_albums_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "file",           null: false
    t.string   "content_type",   null: false
    t.integer  "size",           null: false
    t.string   "key"
    t.string   "etag"
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
  end

  add_index "photos", ["photoable_type", "photoable_id"], name: "index_photos_on_photoable_type_and_photoable_id", using: :btree
  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "spots", force: :cascade do |t|
    t.string    "name"
    t.integer   "status",                                                              default: 0, null: false
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true},             null: false
    t.integer   "user_id"
    t.datetime  "created_at",                                                                      null: false
    t.datetime  "updated_at",                                                                      null: false
  end

  add_index "spots", ["lonlat"], name: "index_spots_on_lonlat", using: :gist
  add_index "spots", ["status"], name: "index_spots_on_status", using: :btree
  add_index "spots", ["user_id"], name: "index_spots_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
