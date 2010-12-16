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

ActiveRecord::Schema.define(:version => 20101216224720) do

  create_table "businesses", :force => true do |t|
    t.string   "name",                :limit => 100
    t.string   "short_name",          :limit => 20
    t.string   "address",             :limit => 100
    t.string   "address_2",           :limit => 100
    t.string   "city",                :limit => 50
    t.string   "state",               :limit => 2
    t.string   "zipcode",             :limit => 10
    t.string   "phone",               :limit => 12
    t.string   "url",                 :limit => 500
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.string   "link_facebook",       :limit => 500
    t.string   "link_twitter",        :limit => 500
    t.string   "yelp_url",            :limit => 500
    t.string   "yelp_avg_rating_url", :limit => 500
    t.string   "hours"
  end

  add_index "businesses", ["user_id"], :name => "index_businesses_on_user_id"

  create_table "businesses_offers", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "offer_id"
  end

  add_index "businesses_offers", ["business_id", "offer_id"], :name => "index_businesses_offers_on_business_id_and_offer_id", :unique => true

  create_table "categories", :force => true do |t|
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
    t.string   "name"
    t.string   "clever_name"
    t.boolean  "active",         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["active"], :name => "index_categories_on_active"
  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["ancestry_depth"], :name => "index_categories_on_ancestry_depth"

  create_table "categories_users", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "user_id"
  end

  add_index "categories_users", ["user_id", "category_id"], :name => "index_categories_users_on_user_id_and_category_id", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "ancestry"
    t.integer  "ancestry_depth",                 :default => 0
    t.string   "text",           :limit => 2500
    t.boolean  "active",                         :default => true
    t.integer  "offer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"
  add_index "comments", ["ancestry_depth"], :name => "index_comments_on_ancestry_depth"
  add_index "comments", ["offer_id", "active"], :name => "index_comments_on_offer_id_and_active"

  create_table "offer_types", :force => true do |t|
    t.string   "name",       :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.string   "lead",             :limit => 100
    t.string   "description",      :limit => 1000
    t.string   "exclusivity_text", :limit => 100
    t.string   "redemption_code",  :limit => 50
    t.integer  "quantity"
    t.date     "active_date"
    t.date     "expire_date"
    t.integer  "offer_type_id"
    t.integer  "category_id"
    t.boolean  "allow_print"
    t.boolean  "allow_mobile"
    t.boolean  "archived"
    t.boolean  "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offers", ["archived", "draft", "active_date", "expire_date", "category_id", "offer_type_id", "allow_mobile"], :name => "by_attributes"

  create_table "opinions", :force => true do |t|
    t.boolean  "liked",      :null => false
    t.integer  "user_id"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opinions", ["offer_id", "liked"], :name => "index_opinions_on_offer_id_and_liked"
  add_index "opinions", ["user_id", "liked"], :name => "index_opinions_on_user_id_and_liked"
  add_index "opinions", ["user_id", "offer_id"], :name => "index_opinions_on_user_id_and_offer_id", :unique => true

  create_table "redemptions", :force => true do |t|
    t.integer  "qty",                :limit => 2
    t.integer  "user_id"
    t.integer  "offer_id"
    t.string   "transaction_number", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redemptions", ["offer_id"], :name => "index_redemptions_on_offer_id"
  add_index "redemptions", ["user_id", "offer_id"], :name => "index_redemptions_on_user_id_and_offer_id", :unique => true

  create_table "user_audits", :force => true do |t|
    t.integer  "user_id"
    t.string   "request",    :limit => 3000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_audits", ["user_id"], :name => "index_user_audits_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",     :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",     :null => false
    t.string   "name",                 :limit => 100
    t.string   "address",              :limit => 100
    t.string   "city",                 :limit => 50
    t.string   "state",                :limit => 2
    t.string   "zipcode",              :limit => 10
    t.string   "phone",                :limit => 12
    t.string   "role",                                :default => "user"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "reset_password_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.integer  "logo_file_size"
    t.string   "logo_content_type"
    t.datetime "logo_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
