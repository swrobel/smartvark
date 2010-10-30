class Business < ActiveRecord::Base
  include Geokit::Geocoders

  acts_as_mappable
  has_many :offers
  has_many :comments
  belongs_to :user

  before_save :set_lat_lng

  before_update :set_yelp_rating

  validates_presence_of :street_address_1, :city, :state, :postal_code

  def short_or_name
    short_name.blank? ? name : short_name
  end

  def city_state_zip
    [city, state].join(',') << ' ' << postal_code
  end

  def address_as_string
    [ street_address_1, city_state_zip].join(',')
  end

  def facebook_link
    return '' if link_facebook.blank?
    if link_facebook.starts_with?('http://facebook.com/')
      link_facebook
    else
      'http://facebook.com/' + link_facebook
    end
  end

  def twitter_link
    return '' if link_twitter.blank?
    if link_twitter.starts_with?('http://twitter.com/')
      link_twitter
    else
      'http://twitter.com/' + link_twitter
    end
  end

  def set_lat_lng
    unless lat && lng
      loc = GoogleGeocoder.geocode(address_as_string)
      if loc.success
        self.lat, self.lng = loc.lat, loc.lng
      end
    end
  end

  def yelp_link
    if yelp_url.starts_with?('http://yelp.com/biz')
      yelp_url
    else
      'http://yelp.com/biz' + yelp_url
    end
  end

  def set_yelp_rating
    return true if phone_1.nil?
    client = Yelp::Client.new
    request = Yelp::Phone::Request::Number.new(
      :phone_number => phone_1.gsub(/\(|\)|\s|-/,''),
      :yws_id => YELP_ID)
    response =  client.search(request)['businesses'].first
    self.yelp_url = response['url']
    self.yelp_avg_rating_url = response['rating_img_url']
    rescue
      logger.info "Could't create yelp rating"
  end
end
