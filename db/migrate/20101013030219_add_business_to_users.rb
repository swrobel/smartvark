class AddBusinessToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :business, :boolean
  end

  def self.down
    remove_column :users, :business
  end
end
