class AddRedemptionCodeToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :redemption_code, :string, :limit => 50
  end

  def self.down
    remove_column :offers, :redemption_code
  end
end
