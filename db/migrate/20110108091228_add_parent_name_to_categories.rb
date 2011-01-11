class AddParentNameToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :parent_name, :string
    
    Category.all.each do |c|
      if c.depth >= 1
        c.parent_name = c.parent.name
        c.save
      end
    end
  end

  def self.down
    remove_column :categories, :parent_name
  end
end
