class BusinessesOffersLookupTable < ActiveRecord::Migration
  def self.up
    create_table :businesses_offers, :id => false do |t|
      t.integer :business_id
      t.integer :offer_id
    end
    
    add_index :businesses_offers, [:business_id, :offer_id], :unique => true
  end

  def self.down
    drop table :businesses_offers
  end
end
