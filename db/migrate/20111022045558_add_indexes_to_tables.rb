class AddIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :businesses, [:latitude, :longitude]
    add_index :offers, :category_id
    add_index :offers, :sqoot_id
    add_index :offers, :user_id
    add_index :sqoot_rows, :import_id
    add_index :sqoot_rows, :offer_id
    add_index :transactions, :transaction_id
    add_index :transactions, :user_id
    add_index :users, [:latitude, :longitude]
    add_index :users, :role
  end

  def self.down
    remove_index :businesses, [:latitude, :longitude]
    remove_index :offers, :category_id
    remove_index :offers, :sqoot_id
    remove_index :offers, :user_id
    remove_index :sqoot_rows, :import_id
    remove_index :sqoot_rows, :offer_id
    remove_index :transactions, :transaction_id
    remove_index :transactions, :user_id
    remove_index :users, [:latitude, :longitude]
    remove_index :users, :role
  end
end
