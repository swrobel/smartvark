class AddRedemptionLinkToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :redemption_link, :string
  end

  def self.down
    remove_column :offers, :redemption_link
  end
end
