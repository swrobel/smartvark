class AddArchivedToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :archived, :boolean
  end

  def self.down
    remove_column :offers, :archived
  end
end
