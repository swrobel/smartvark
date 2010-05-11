class Business < ActiveRecord::Base
  include Geokit::Geocoders
  acts_as_mappable
  has_many :offers
  has_many :comments

  before_save :set_lat_lng

  validates_presence_of :street_address_1, :city, :state, :postal_code

  def address_as_string
    [ street_address_1, city, state] .join(',') << postal_code
  end

  def set_lat_lng
    unless lat && lng
      loc = GoogleGeocoder.geocode(address_as_string)
      if loc.success
        self.lat, self.lng = loc.lat, loc.lng
      end
    end
  end
end
