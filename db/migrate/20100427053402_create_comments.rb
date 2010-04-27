class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :text, :limit => 2500
      t.boolean :active, :default => true
      t.integer :parent_id
      t.integer :offer_id
      t.integer :business_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
