class ChangeOfferEndDateToDateTime < ActiveRecord::Migration
  def self.up
    change_column :offers, :end_date, :datetime
  end

  def self.down
    change_column :offers, :end_date, :date
  end
end
