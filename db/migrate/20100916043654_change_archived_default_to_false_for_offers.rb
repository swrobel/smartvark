class ChangeArchivedDefaultToFalseForOffers < ActiveRecord::Migration
  def self.up
    change_column :offers, :archived, :boolean, :default => false
    Offer.find_all_by_archived(nil).each { |offer| offer.update_attribute(:archived, false) }
  end

  def self.down
    change_column :offers, :archived, :boolean
  end
end
