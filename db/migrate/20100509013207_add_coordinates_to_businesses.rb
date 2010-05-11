class AddCoordinatesToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :lat, :float
    add_column :businesses, :lng, :float
  end

  def self.down
    remove_column :businesses, :lng
    remove_column :businesses, :lat
  end
end
