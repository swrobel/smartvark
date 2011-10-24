class CreateEmailedOffers < ActiveRecord::Migration
  def self.up
    create_table :emailed_offers do |t|
      t.integer :email_id
      t.integer :user_id
      t.integer :offer_id

      t.timestamps
    end

    add_index :emailed_offers, :email_id
    add_index :emailed_offers, :user_id
    add_index :emailed_offers, :offer_id
  end

  def self.down
    drop_table :emailed_offers
  end
end
