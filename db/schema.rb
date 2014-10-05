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

ActiveRecord::Schema.define(version: 20141005055135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hops", force: true do |t|
    t.string   "code"
    t.boolean  "planned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.integer  "user_id"
    t.integer  "hop_id"
    t.string   "final_destination_lat"
    t.string   "final_destination_long"
    t.boolean  "active",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "first"
    t.string   "last"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bactrack_id",                         default: ""
    t.string   "drunk_emoji",                         default: "https://abs.twimg.com/emoji/v1/72x72/1f610.png"
    t.integer  "booze_level",                         default: 0
    t.decimal  "latest_bac",  precision: 3, scale: 2, default: 0.0
    t.integer  "hop_id"
  end

end
