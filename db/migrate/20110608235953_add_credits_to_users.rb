class AddCreditsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :credits, :int, :default => 0
    User.update_all ["credits = ?", 0]
  end

  def self.down
    remove_column :users, :credits
  end
end
