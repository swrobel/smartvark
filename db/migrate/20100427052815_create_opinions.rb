class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.boolean :liked, :null => false
      t.integer :user_id
      t.integer :offer_id

      t.timestamps
    end
    
    add_index :opinions, [:user_id, :offer_id], :unique => true
    add_index :opinions, [:user_id, :liked]
    add_index :opinions, [:offer_id, :liked]
  end

  def self.down
    drop_table :opinions
  end
end
