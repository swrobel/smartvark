class AddFieldToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :short_name, :string
  end

  def self.down
    remove_column :businesses, :short_name
  end
end
