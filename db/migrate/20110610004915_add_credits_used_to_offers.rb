class AddCreditsUsedToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :credits_used, :int
    Offer.update_all ["credits_used = ?", 0]
  end

  def self.down
    remove_column :offers, :credits_used
  end
end
