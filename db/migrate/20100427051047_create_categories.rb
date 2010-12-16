class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :ancestry
      t.integer :ancestry_depth, :default => 0
      t.string :name
      t.string :clever_name
      t.boolean :active, :default => true

      t.timestamps
    end
    
    add_index :categories, :active
    add_index :categories, :ancestry
    add_index :categories, :ancestry_depth
  end

  def self.down
    drop_table :categories
  end
end
