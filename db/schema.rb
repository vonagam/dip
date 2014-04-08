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

ActiveRecord::Schema.define(version: 20140404160435) do

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "status"
    t.text     "description"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["creator_id"], name: "index_games_on_creator_id", using: :btree

  create_table "orders", force: true do |t|
    t.text    "data"
    t.integer "side_id"
    t.integer "state_id"
  end

  add_index "orders", ["side_id"], name: "index_orders_on_side_id", using: :btree
  add_index "orders", ["state_id"], name: "index_orders_on_state_id", using: :btree

  create_table "sides", force: true do |t|
    t.string  "name"
    t.integer "game_id"
    t.integer "user_id"
  end

  add_index "sides", ["game_id"], name: "index_sides_on_game_id", using: :btree
  add_index "sides", ["user_id"], name: "index_sides_on_user_id", using: :btree

  create_table "states", force: true do |t|
    t.text    "data"
    t.float   "date"
    t.string  "type"
    t.integer "game_id"
  end

  add_index "states", ["game_id"], name: "index_states_on_game_id", using: :btree

  create_table "users", force: true do |t|
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
