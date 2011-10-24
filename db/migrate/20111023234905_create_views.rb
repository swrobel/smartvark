class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.integer :user_id
      t.integer :offer_id

      t.timestamps
    end

    add_index :views, :user_id
    add_index :views, :offer_id
  end

  def self.down
    drop_table :views
  end
end
