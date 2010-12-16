class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.integer :user_id
      t.string :name, :limit => 100
      t.string :short_name, :limit => 20
      t.string :address, :limit => 100
      t.string :address_2, :limit => 100
      t.string :city, :limit => 50
      t.string :state, :limit => 2
      t.string :zipcode, :limit => 10
      t.string :phone, :limit => 12
      t.string :hours
      t.string :url, :limit => 500
      t.string :facebook_url, :limit => 500
      t.string :twitter_url, :limit => 500
      t.string :yelp_url, :limit => 500
      t.string :yelp_avg_rating_url, :limit => 500
      t.float :lat
      t.float :lng

      t.timestamps
    end
    
    add_index :businesses, :user_id
  end

  def self.down
    drop_table :businesses
  end
end
