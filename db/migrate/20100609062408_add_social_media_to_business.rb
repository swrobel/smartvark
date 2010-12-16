class AddSocialMediaToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :link_facebook, :string, :limit => 500
    add_column :businesses, :link_twitter, :string, :limit => 500
    add_column :businesses, :yelp_url, :string, :limit => 500
    add_column :businesses, :yelp_avg_rating_url, :string, :limit => 500
  end

  def self.down
    remove_column :businesses, :yelp_star_rating_url
    remove_column :businesses, :yelp_url
    remove_column :businesses, :link_twitter
    remove_column :businesses, :link_facebook
  end
end
