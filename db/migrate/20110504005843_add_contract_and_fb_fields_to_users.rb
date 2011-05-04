class AddContractAndFbFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :contract_accepted_at, :datetime
    add_column :users, :facebook_user, :boolean, :default => false
  end

  def self.down
    remove_column :users, :facebook_user
    remove_column :users, :contract_accepted_at
  end
end
