class CreateOfferTypes < ActiveRecord::Migration
  def self.up
    create_table :offer_types do |t|
      t.string :name, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :offer_types
  end
end
