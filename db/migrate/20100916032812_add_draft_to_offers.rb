class AddDraftToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :offers, :draft
  end
end
