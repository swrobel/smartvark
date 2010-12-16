class CreateRedemptions < ActiveRecord::Migration
  def self.up
    create_table :redemptions do |t|
      t.integer :qty, :limit => 1
      t.integer :user_id
      t.integer :offer_id
      t.string :transaction_number, :limit => 50

      t.timestamps
    end
    
    add_index :redemptions, [:user_id, :offer_id], :unique => true
    add_index :redemptions, :offer_id
  end

  def self.down
    drop_table :redemptions
  end
end
