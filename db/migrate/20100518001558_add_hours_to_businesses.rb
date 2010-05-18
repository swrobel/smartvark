class AddHoursToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :hours, :string
  end

  def self.down
    remove_column :businesses, :hours
  end
end
