class AddWebRedemptionsFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :web_redemptions, :boolean, :default => false
    User.update_all ["web_redemptions = ?", false]
  end

  def self.down
    remove_column :users, :web_redemptions
  end
end
