class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string :title, :limit => 100
      t.string :description, :limit => 500
      t.string :fine_print, :limit => 500
      t.string :redemption_code, :limit => 25
      t.integer :redemption_limit
      t.date :start_date
      t.date :end_date
      t.integer :offer_type_id
      t.integer :category_id
      t.boolean :allow_print
      t.boolean :allow_mobile
      t.boolean :archived
      t.boolean :draft

      t.timestamps
    end
    
    add_index :offers, [:archived, :draft, :start_date, :end_date, :category_id, :offer_type_id, :allow_mobile], :name => "by_attributes"
  end

  def self.down
    drop_table :offers
  end
end
