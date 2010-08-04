class CreateOfferTypes < ActiveRecord::Migration
  def self.up
    create_table :offer_types do |t|
      t.string :name

      t.timestamps
    end

    %w(coupon deal event).each { |name| OfferType.create(:name => name) }
  end

  def self.down
    drop_table :offer_types
  end
end
