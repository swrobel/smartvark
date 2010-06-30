class IncreaseLengthOfUrlColumnsInBusinesses < ActiveRecord::Migration
  def self.up
    change_column :businesses, :url, :string, :limit => 500
    change_column :businesses, :link_facebook, :string, :limit => 500
    change_column :businesses, :link_twitter, :string, :limit => 500
    change_column :businesses, :yelp_url, :string, :limit => 500
    change_column :businesses, :yelp_avg_rating_url, :string, :limit => 500
  end

  def self.down
    change_column :businesses, :url, :string, :limit => 50
    change_column :businesses, :link_facebook, :string, :limit => 50
    change_column :businesses, :link_twitter, :string, :limit => 50
    change_column :businesses, :yelp_url, :string, :limit => 50
    change_column :businesses, :yelp_avg_rating_url, :string, :limit => 50
  end
end
