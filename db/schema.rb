# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100427063804) do

  create_table "businesses", :force => true do |t|
    t.string   "name",             :limit => 50
    t.string   "street_address_1", :limit => 100
    t.string   "street_address_2", :limit => 20
    t.string   "city",             :limit => 50
    t.string   "state",            :limit => 20
    t.string   "postal_code",      :limit => 15
    t.string   "country",          :limit => 3
    t.string   "phone_1",          :limit => 15
    t.string   "phone_2",          :limit => 15
    t.string   "fax",              :limit => 15
    t.string   "url",              :limit => 50
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "text",        :limit => 2500
    t.boolean  "active",                      :default => true
    t.integer  "parent_id"
    t.integer  "offer_id"
    t.integer  "business_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.string   "lead",                :limit => 100
    t.string   "description",         :limit => 1000
    t.string   "exclusivity_text",    :limit => 100
    t.integer  "quantity"
    t.datetime "expiry_datetime"
    t.integer  "category_id"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coupon_file_name"
    t.string   "coupon_content_type"
    t.integer  "coupon_file_size"
    t.datetime "coupon_updated_at"
    t.string   "redemption_code",     :limit => 50
  end

  create_table "opinions", :force => true do |t|
    t.boolean  "liked",      :null => false
    t.integer  "user_id"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redemptions", :force => true do |t|
    t.integer  "qty",                :limit => 1
    t.integer  "user_id"
    t.integer  "offer_id"
    t.string   "transaction_number", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_audits", :force => true do |t|
    t.integer  "user_id"
    t.string   "request",    :limit => 3000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end