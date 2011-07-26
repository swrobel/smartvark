class AddYipitFieldsToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :yipit_id, :integer
    add_column :offers, :source, :string
    add_column :offers, :image_url_big, :string
    add_column :offers, :image_url_small, :string
    change_column_default :offers, :allow_print, true
    change_column_default :offers, :allow_mobile, true
  end

  def self.down
    remove_column :offers, :image_url_small
    remove_column :offers, :image_url_big
    remove_column :offers, :source
    remove_column :offers, :yipit_id
  end
end
