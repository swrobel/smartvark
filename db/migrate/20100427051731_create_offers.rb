class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string :lead, :limit => 100
      t.string :description, :limit => 1000
      t.string :exclusivity_text, :limit => 100
      t.string :redemption_code, :limit => 50
      t.integer :quantity
      t.date :active_date
      t.date :expire_date
      t.integer :offer_type_id
      t.integer :category_id
      t.boolean :allow_print
      t.boolean :allow_mobile
      t.boolean :archived
      t.boolean :draft

      t.timestamps
    end
    
    add_index :offers, [:archived, :draft, :active_date, :expire_date, :category_id, :offer_type_id, :allow_mobile], :name => "by_attributes"
  end

  def self.down
    drop_table :offers
  end
end
