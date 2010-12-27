class AddCachedSlugToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :cached_slug, :string
    add_index :businesses, :cached_slug, :unique => true
  end

  def self.down
    remove_index :businesses, :cached_slug
    remove_column :businesses, :cached_slug
  end
end
