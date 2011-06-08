class AddWebsiteToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :website, :string
  end

  def self.down
    remove_column :businesses, :website
  end
end
