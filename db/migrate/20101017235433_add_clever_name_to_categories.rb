class AddCleverNameToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :clever_name, :string
  end

  def self.down
    remove_column :categories, :clever_name
  end
end
