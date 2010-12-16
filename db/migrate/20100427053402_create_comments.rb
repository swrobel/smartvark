class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :ancestry
      t.integer :ancestry_depth, :default => 0
      t.string :text, :limit => 2500
      t.boolean :active, :default => true
      t.integer :offer_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :comments, [:offer_id, :active]
    add_index :comments, :ancestry
    add_index :comments, :ancestry_depth
  end

  def self.down
    drop_table :comments
  end
end
