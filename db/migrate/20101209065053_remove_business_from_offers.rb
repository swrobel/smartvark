class RemoveBusinessFromOffers < ActiveRecord::Migration
  def self.up
    remove_column :offers, :business_id
  end

  def self.down
    add_column :offers, :business_id, :integer
  end
end
