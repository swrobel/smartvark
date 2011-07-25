class AddNewCustOnlyToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :new_cust_only, :boolean, :default => false
    Offer.update_all ["new_cust_only = ?", false]
  end

  def self.down
    remove_column :offers, :new_cust_only
  end
end
