class AddSubclassToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string
    add_column :users, :logo_name, :string
    add_column :users, :logo_size, :integer
  end

  def self.down
    remove_column :users, :logo_size
    remove_column :users, :logo_name
    remove_column :users, :type
  end
end
