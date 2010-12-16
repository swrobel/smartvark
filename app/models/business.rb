class Business < ActiveRecord::Base
  include Geokit::Geocoders

  acts_as_mappable
  belongs_to :user
  has_and_belongs_to_many :offers

  before_save :set_lat_lng

  before_update :set_yelp_rating

  validates_presence_of :name, :address, :city, :state, :zipcode, :phone_1

  def short_or_name
    short_name.blank? ? name : short_name
  end

  def to_param
    "#{id}-#{URI.escape(CGI.escape(name),'.')}"
  end

  def city_state_zip
    [city, state].join(',') << ' ' << zipcode
  end

  def address_as_string
    [ address, city_state_zip].join(',')
  end

  def facebook_link
    return '' if facebook_url.blank?
    if facebook_url.include?('facebook.com/')
      facebook_url
    else
      'http://facebook.com/' + facebook_url
    end
  end

  def twitter_link
    return '' if twitter_url.blank?
    if twitter_url.include?('twitter.com/')
      twitter_url
    else
      'http://twitter.com/' + twitter_url
    end
  end
  
  def yelp_link
    if yelp_url.include?('yelp.com/')
      yelp_url
    else
      'http://yelp.com/biz/' + yelp_url
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
