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

ActiveRecord::Schema.define(:version => 20110613034106) do

  create_table "businesses", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",                :limit => 100
    t.string   "short_name",          :limit => 20
    t.string   "address",             :limit => 100
    t.string   "address_2",           :limit => 100
    t.string   "city",                :limit => 50
    t.string   "state",               :limit => 2
    t.string   "zipcode",             :limit => 10
    t.string   "phone",               :limit => 12
    t.string   "hours"
    t.string   "url"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "yelp_url"
    t.string   "yelp_mobile_url"
    t.string   "yelp_rating_img_url"
    t.integer  "yelp_review_count",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.string   "website"
  end

  add_index "businesses", ["cached_slug"], :name => "index_businesses_on_cached_slug", :unique => true
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
    t.string   "cached_slug"
    t.string   "parent_name"
  end

  add_index "categories", ["active"], :name => "index_categories_on_active"
  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["ancestry_depth"], :name => "index_categories_on_ancestry_depth"
  add_index "categories", ["cached_slug"], :name => "index_categories_on_cached_slug", :unique => true

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

  create_table "geocodes", :force => true do |t|
    t.decimal "latitude",    :precision => 15, :scale => 12
    t.decimal "longitude",   :precision => 15, :scale => 12
    t.string  "query"
    t.string  "street"
    t.string  "locality"
    t.string  "region"
    t.string  "postal_code"
    t.string  "country"
    t.string  "precision"
  end

  add_index "geocodes", ["country"], :name => "geocodes_country_index"
  add_index "geocodes", ["latitude"], :name => "geocodes_latitude_index"
  add_index "geocodes", ["locality"], :name => "geocodes_locality_index"
  add_index "geocodes", ["longitude"], :name => "geocodes_longitude_index"
  add_index "geocodes", ["postal_code"], :name => "geocodes_postal_code_index"
  add_index "geocodes", ["precision"], :name => "geocodes_precision_index"
  add_index "geocodes", ["query"], :name => "geocodes_query_index", :unique => true
  add_index "geocodes", ["region"], :name => "geocodes_region_index"

  create_table "geocodings", :force => true do |t|
    t.integer "geocodable_id"
    t.integer "geocode_id"
    t.string  "geocodable_type"
  end

  add_index "geocodings", ["geocodable_id"], :name => "geocodings_geocodable_id_index"
  add_index "geocodings", ["geocodable_type"], :name => "geocodings_geocodable_type_index"
  add_index "geocodings", ["geocode_id"], :name => "geocodings_geocode_id_index"

  create_table "offer_types", :force => true do |t|
    t.string   "name",       :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",            :limit => 100
    t.string   "description",      :limit => 500
    t.string   "fine_print",       :limit => 500
    t.string   "redemption_code",  :limit => 25
    t.integer  "redemption_limit"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "offer_type_id"
    t.integer  "category_id"
    t.boolean  "allow_print"
    t.boolean  "allow_mobile"
    t.boolean  "archived",                        :default => false
    t.boolean  "draft",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "credits_used"
  end

  add_index "offers", ["archived", "draft", "start_date", "end_date", "category_id", "offer_type_id", "allow_mobile"], :name => "by_attributes"
  add_index "offers", ["cached_slug"], :name => "index_offers_on_cached_slug", :unique => true

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

  create_table "potentials", :force => true do |t|
    t.string   "email"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "transactions", :force => true do |t|
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_audits", :force => true do |t|
    t.integer  "user_id"
    t.string   "browser"
    t.string   "os"
    t.string   "controller"
    t.string   "action"
    t.string   "request",    :limit => 3000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_audits", ["action"], :name => "index_user_audits_on_action"
  add_index "user_audits", ["controller", "action"], :name => "index_user_audits_on_controller_and_action"
  add_index "user_audits", ["user_id"], :name => "index_user_audits_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",     :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "name",                   :limit => 100
    t.string   "address",                :limit => 100
    t.string   "city",                   :limit => 50
    t.string   "state",                  :limit => 2
    t.string   "zipcode",                :limit => 10
    t.string   "phone",                  :limit => 12
    t.string   "gender",                 :limit => 1
    t.date     "birthday"
    t.string   "role",                                  :default => "user"
    t.integer  "category_id"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.integer  "logo_file_size"
    t.string   "logo_content_type"
    t.datetime "logo_updated_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "contract_accepted_at"
    t.boolean  "facebook_user",                         :default => false
    t.integer  "credits",                               :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
