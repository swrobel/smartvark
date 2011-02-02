class CreatePotentials < ActiveRecord::Migration
  def self.up
    create_table :potentials do |t|
      t.string :email
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :potentials
  end
end
