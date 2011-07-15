class RenameClothesToApparel < ActiveRecord::Migration
  def self.up
  	Category.update_all "name = 'Apparel'", "name = 'Clothes'"
  	Category.update_all "parent_name = 'Apparel'", "parent_name = 'Clothes'"
  end

  def self.down
  	Category.update_all "name = 'Clothes'", "name = 'Apparel'"
  	Category.update_all "parent_name = 'Clothes'", "parent_name = 'Apparel'"
  end
end
