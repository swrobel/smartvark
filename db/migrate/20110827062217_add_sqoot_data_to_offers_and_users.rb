class AddSqootDataToOffersAndUsers < ActiveRecord::Migration
  def self.up
    add_column :offers, :sqoot_id, :integer
    change_column :offers, :description, :text
    change_column :offers, :fine_print, :text

    User.create(:email => "api@sqoot.com", :password => "sq0o7!") { |u| u.role = "business" }
  end

  def self.down
    remove_column :offers, :sqoot_id
    change_column :offers, :description, :string, :limit => 500
    change_column :offers, :fine_print, :string, :limit => 500
  end
end
