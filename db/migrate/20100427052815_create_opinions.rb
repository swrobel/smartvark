class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.boolean :liked, :null => false
      t.integer :user_id
      t.integer :offer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :opinions
  end
end
