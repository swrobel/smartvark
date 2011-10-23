class AddNewSqootFieldsToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :commission, :decimal
    add_column :offers, :num_sold, :integer
  end

  def self.down
    remove_column :offers, :num_sold
    remove_column :offers, :commission
  end
end
