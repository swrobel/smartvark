class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string :lead, :limit => 100
      t.string :description, :limit => 1000
      t.string :exclusivity_text, :limit => 100
      t.integer :quantity
      t.datetime :expiry_datetime
      t.integer :category_id
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
