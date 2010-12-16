require File.dirname(__FILE__) + '/../test_helper'

class OfferTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "An offer" do
    setup do
      business = Business.create({
        :name => 'Cold Stone',
        :address => '100 Wilshire Blvd.',
        :city => 'Santa Monica',
        :state => 'CA',
        :zipcode => '90401',
        :lat => 34.016,
        :lng => -118.5
      })
      @offer = Offer.create({
        :lead => 'Free ice cream',
        :business => business
      })
      assert @offer.valid?
    end

    should "be not be found" do
      found = Offer.search( :search_terms => 'off').include?(@offer)
      assert_equal false, found
    end

    should "be found" do
      found = Offer.search( :search_terms => 'free', :location => 'santa monica, ca').include?(@offer)
      assert found
    end


  end
end
