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

ActiveRecord::Schema.define(:version => 20100804085908) do

  create_table "businesses", :force => true do |t|
    t.string   "name",                :limit => 50,  :null => false
    t.string   "street_address_1",    :limit => 100, :null => false
    t.string   "street_address_2",    :limit => 20,  :null => false
    t.string   "city",                :limit => 50,  :null => false
    t.string   "state",               :limit => 20,  :null => false
    t.string   "postal_code",         :limit => 15,  :null => false
    t.string   "country",             :limit => 3,   :null => false
    t.string   "phone_1",             :limit => 15,  :null => false
    t.string   "phone_2",             :limit => 15,  :null => false
    t.string   "fax",                 :limit => 15,  :null => false
    t.string   "url",                 :limit => 500, :null => false
    t.integer  "parent_id",                          :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.float    "lat",                                :null => false
    t.float    "lng",                                :null => false
    t.string   "hours",                              :null => false
    t.string   "link_facebook",       :limit => 500, :null => false
    t.string   "link_twitter",        :limit => 500, :null => false
    t.string   "yelp_url",            :limit => 500, :null => false
    t.string   "yelp_avg_rating_url", :limit => 500, :null => false
    t.string   "short_name",                         :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name",                         :null => false
    t.boolean  "active",     :default => true, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "parent_id",                    :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "text",        :limit => 2500,                   :null => false
    t.boolean  "active",                      :default => true, :null => false
    t.integer  "parent_id",                                     :null => false
    t.integer  "offer_id",                                      :null => false
    t.integer  "business_id",                                   :null => false
    t.integer  "user_id",                                       :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "offer_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "offers", :force => true do |t|
    t.string   "lead",                :limit => 100,  :null => false
    t.string   "description",         :limit => 1000, :null => false
    t.string   "exclusivity_text",    :limit => 100,  :null => false
    t.integer  "quantity",                            :null => false
    t.datetime "expiry_datetime",                     :null => false
    t.integer  "category_id",                         :null => false
    t.integer  "business_id",                         :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "coupon_file_name",                    :null => false
    t.string   "coupon_content_type",                 :null => false
    t.integer  "coupon_file_size",                    :null => false
    t.datetime "coupon_updated_at",                   :null => false
    t.string   "redemption_code",     :limit => 50,   :null => false
    t.boolean  "archived",                            :null => false
    t.date     "offer_active_on",                     :null => false
    t.string   "offer_type",          :limit => 20,   :null => false
    t.boolean  "allow_print",                         :null => false
    t.boolean  "allow_mobile",                        :null => false
  end

  create_table "opinions", :force => true do |t|
    t.boolean  "liked",      :null => false
    t.integer  "user_id",    :null => false
    t.integer  "offer_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "redemptions", :force => true do |t|
    t.integer  "qty",                :limit => 1,  :null => false
    t.integer  "user_id",                          :null => false
    t.integer  "offer_id",                         :null => false
    t.string   "transaction_number", :limit => 50, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "user_audits", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.string   "request",    :limit => 3000, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                             :null => false
    t.string   "email",                                             :null => false
    t.string   "crypted_password",                                  :null => false
    t.string   "password_salt",                                     :null => false
    t.string   "persistence_token",                                 :null => false
    t.string   "single_access_token",                               :null => false
    t.string   "perishable_token",                                  :null => false
    t.integer  "login_count",                        :default => 0, :null => false
    t.integer  "failed_login_count",                 :default => 0, :null => false
    t.datetime "last_request_at",                                   :null => false
    t.datetime "current_login_at",                                  :null => false
    t.datetime "last_login_at",                                     :null => false
    t.string   "current_login_ip",                                  :null => false
    t.string   "last_login_ip",                                     :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "name",                 :limit => 50,                :null => false
    t.string   "address",              :limit => 50,                :null => false
    t.string   "city",                 :limit => 50,                :null => false
    t.string   "state",                :limit => 2,                 :null => false
    t.string   "zipcode",              :limit => 11,                :null => false
    t.string   "phone",                :limit => 15,                :null => false
    t.integer  "carrier",              :limit => 2,                 :null => false
    t.integer  "facebook_uid",         :limit => 8,                 :null => false
    t.string   "facebook_session_key",                              :null => false
  end

end
