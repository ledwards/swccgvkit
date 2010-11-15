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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101104032531) do

  create_table "card_attributes", :force => true do |t|
    t.string  "name"
    t.integer "value"
    t.integer "card_id"
  end

  create_table "card_characteristics", :force => true do |t|
    t.string "name"
  end

  create_table "card_characteristics_cards", :id => false, :force => true do |t|
    t.integer "card_id"
    t.integer "card_characteristic_id"
  end

  create_table "cardlist_items", :force => true do |t|
    t.integer "cardlist_id"
    t.integer "card_id"
    t.integer "quantity"
  end

  create_table "cardlists", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.string   "title"
    t.string   "side"
    t.string   "lore"
    t.string   "gametext"
    t.string   "rarity"
    t.string   "uniqueness"
    t.string   "card_type"
    t.string   "subtype"
    t.string   "expansion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_image_file_name"
    t.string   "card_image_content_type"
    t.integer  "card_image_file_size"
    t.datetime "card_image_updated_at"
    t.string   "vslip_image_file_name"
    t.string   "vslip_image_content_type"
    t.integer  "vslip_image_file_size"
    t.datetime "vslip_image_updated_at"
    t.string   "card_back_image_file_name"
    t.string   "card_back_image_content_type"
    t.integer  "card_back_image_file_size"
    t.datetime "card_back_image_updated_at"
    t.string   "vslip_back_image_file_name"
    t.string   "vslip_back_image_content_type"
    t.integer  "vslip_back_image_file_size"
    t.datetime "vslip_back_image_updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
