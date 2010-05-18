class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string, :limit => 50
    add_column :users, :address, :string, :limit => 50
    add_column :users, :city, :string, :limit => 50
    add_column :users, :state, :string, :limit => 2
    add_column :users, :zipcode, :string, :limit => 11
    add_column :users, :phone, :string, :limit => 15
    add_column :users, :carrier, :integer, :limit => 2
  end

  def self.down
    remove_column :users, :phone
    remove_column :users, :zipcode
    remove_column :users, :city
    remove_column :users, :address
    remove_column :users, :name
  end
end
