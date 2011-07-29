class CreateYipitRows < ActiveRecord::Migration
  def self.up
    create_table :yipit_rows do |t|
      t.integer :import_id
      t.integer :offer_id
      t.integer :yipit_id
      t.boolean :created_biz
      t.boolean :created_offer
      t.text :row_data
      t.text :row_errors

      t.timestamps
    end
  end

  def self.down
    drop_table :yipit_rows
  end
end
