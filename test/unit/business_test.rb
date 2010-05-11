require File.dirname(__FILE__) + '/../test_helper'

class BusinessTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  #
  context "A business" do
    setup do
      @business = Business.create(:name  => 'Acme')
    end

    should "not have a lat, lng" do
      @business = Business.new(:name  => 'Acme')
      assert_equal false, @business.valid?
      assert_nil @business.lat
      assert_nil @business.lng
    end


    should "have a lat, lng" do
      @business = Business.new(:name  => 'Acme')
      assert @business.update_attributes({
        :street_address_1 => '100 Wilshire Blvd',
        :city => 'Santa Monica',
        :state => 'CA',
        :postal_code => '90401'
      })
      assert_in_delta 34.016, @business.lat, 0.01
      assert_in_delta -118.5, @business.lng, 0.01
    end
  end
end
