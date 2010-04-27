class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.string :name, :limit => 50
      t.string :street_address_1, :limit => 100
      t.string :street_address_2, :limit => 20
      t.string :city, :limit => 50
      t.string :state, :limit => 20
      t.string :postal_code, :limit => 15
      t.string :country, :limit => 3
      t.string :phone_1, :limit => 15
      t.string :phone_2, :limit => 15
      t.string :fax, :limit => 15
      t.string :url, :limit => 50
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :businesses
  end
end
