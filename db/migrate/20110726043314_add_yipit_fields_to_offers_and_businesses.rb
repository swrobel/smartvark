class AddYipitFieldsToOffersAndBusinesses < ActiveRecord::Migration
  def self.up
    # Offers
    add_column :offers, :yipit_id, :integer
    add_column :offers, :source, :string
    add_column :offers, :image_url_big, :string
    add_column :offers, :image_url_small, :string
    change_column_default :offers, :allow_print, true
    change_column_default :offers, :allow_mobile, true

    # Businesses
    add_column :businesses, :yipit_id, :integer

    # User
    User.create(:email => "api@yipit.com", :password => "y1p17!") { |u| u.role = "business" }
  end

  def self.down
    # Offers
    remove_column :offers, :image_url_small
    remove_column :offers, :image_url_big
    remove_column :offers, :source
    remove_column :offers, :yipit_id

    # Businesses
    remove_column :businesses, :yipit_id
  end
end
