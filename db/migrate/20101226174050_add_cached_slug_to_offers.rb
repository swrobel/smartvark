class AddCachedSlugToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :cached_slug, :string
    add_index  :offers, :cached_slug, :unique => true
  end

  def self.down
    remove_index  :offers, :cached_slug
    remove_column :offers, :cached_slug
  end
end
