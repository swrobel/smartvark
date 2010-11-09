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

ActiveRecord::Schema.define(:version => 20101109085119) do

  create_table "access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",       :limit => 30
    t.string   "key"
    t.string   "token",      :limit => 1024
    t.string   "secret"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_tokens", ["key"], :name => "index_access_tokens_on_key", :unique => true

  create_table "businesses", :force => true do |t|
    t.string    "name",                :limit => 50
    t.string    "street_address_1",    :limit => 100
    t.string    "street_address_2",    :limit => 20
    t.string    "city",                :limit => 50
    t.string    "state",               :limit => 20
    t.string    "postal_code",         :limit => 15
    t.string    "country",             :limit => 3
    t.string    "phone_1",             :limit => 15
    t.string    "phone_2",             :limit => 15
    t.string    "fax",                 :limit => 15
    t.string    "url",                 :limit => 500
    t.integer   "parent_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.float     "lat"
    t.float     "lng"
    t.string    "hours"
    t.string    "link_facebook",       :limit => 500
    t.string    "link_twitter",        :limit => 500
    t.string    "yelp_url",            :limit => 500
    t.string    "yelp_avg_rating_url", :limit => 500
    t.string    "short_name"
    t.integer   "user_id"
  end

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.boolean   "active",      :default => true
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "parent_id"
    t.string    "clever_name"
  end

  create_table "categories_users", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "user_id"
  end

  create_table "comments", :force => true do |t|
    t.string    "text",        :limit => 2500
    t.boolean   "active",                      :default => true
    t.integer   "parent_id"
    t.integer   "offer_id"
    t.integer   "business_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "offer_types", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.string    "lead",             :limit => 100
    t.string    "description",      :limit => 1000
    t.string    "exclusivity_text", :limit => 100
    t.integer   "quantity"
    t.timestamp "expiry_datetime"
    t.integer   "category_id"
    t.integer   "business_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "redemption_code",  :limit => 50
    t.boolean   "archived",                         :default => false
    t.date      "offer_active_on"
    t.string    "offer_type",       :limit => 20
    t.boolean   "allow_print"
    t.boolean   "allow_mobile"
    t.boolean   "draft",                            :default => false
  end

  create_table "opinions", :force => true do |t|
    t.boolean   "liked",      :null => false
    t.integer   "user_id"
    t.integer   "offer_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "redemptions", :force => true do |t|
    t.integer   "qty"
    t.integer   "user_id"
    t.integer   "offer_id"
    t.string    "transaction_number", :limit => 50
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "user_audits", :force => true do |t|
    t.integer   "user_id"
    t.string    "request",    :limit => 3000
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                            :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                       :default => 0, :null => false
    t.integer  "failed_login_count",                :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                :limit => 50
    t.string   "address",             :limit => 50
    t.string   "city",                :limit => 50
    t.string   "state",               :limit => 2
    t.string   "zipcode",             :limit => 11
    t.string   "phone",               :limit => 15
    t.integer  "carrier"
    t.string   "type"
    t.string   "logo_file_name"
    t.integer  "logo_file_size"
    t.string   "logo_content_type"
    t.datetime "logo_updated_at"
    t.boolean  "business"
    t.integer  "active_token_id"
  end

  add_index "users", ["active_token_id"], :name => "index_users_on_active_token_id"

end
