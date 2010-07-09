class AddFieldsToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :offer_active_on, :date
    add_column :offers, :offer_type, :string, :limit => 20
    add_column :offers, :allow_print, :boolean
    add_column :offers, :allow_mobile, :boolean
  end

  def self.down
    remove_column :offers, :allow_mobile
    remove_column :offers, :allow_print
    remove_column :offers, :offer_type
    remove_column :offers, :offer_active_on
  end
end
