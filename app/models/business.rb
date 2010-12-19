class Business < ActiveRecord::Base
  include Geokit::Geocoders
  acts_as_mappable
  
  belongs_to :user
  has_and_belongs_to_many :offers

  nilify_blanks :before => :validation
  before_validation :get_yelp_data
  before_save :get_lat_lng
  before_save :format_phone
  
  HUMANIZED_ATTRIBUTES = {
    :name => "Location Name",
    :address => "Address 1",
    :zipcode => "Zip"
  }

  validates :name, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zipcode, :presence => true
  validates :phone, :phone_format => true

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
MANIZED_ATTRIBUTES = {
    :allow_mobile => "",
    :businesses => "",
    :title => "Title"
  }
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

private
  def get_lat_lng
    unless lat && lng
      loc = GoogleGeocoder.geocode(address_as_string)
      if loc.success
        self.lat, self.lng = loc.lat, loc.lng
      end
    end
  end

  def get_yelp_data
    return if yelp_url.nil?
    consumer = OAuth::Consumer.new(YELP_CONSUMER_KEY, YELP_CONSUMER_SECRET, {:site => "http://api.yelp.com"})
    access_token = OAuth::AccessToken.new(consumer, YELP_TOKEN, YELP_TOKEN_SECRET)
    
    path = "/v2/business/" + yelp_url
    result = access_token.get(path).body
    result = Yajl::Parser.parse(result)
    
    self.yelp_mobile_url = result["mobile_url"]
    self.yelp_rating_img_url = result["rating_img_url"]
    self.yelp_review_count = result["review_count"]
    self.name = result["name"] unless name
    self.phone = result["phone"] unless phone
    location = result["location"]
    self.address = location["address"][0] unless address
    self.address_2 = location["address"][1] unless address_2
    self.city = location["city"] unless city
    self.state = location["state_code"] unless state
    self.zipcode = location["postal_code"] unless zipcode
    coordinate = location["coordinate"]
    self.lat = coordinate["latitude"] unless lng
    self.lng = coordinate["longitude"] unless lng
    
  rescue Exception => e
    logger.info "Yelp failure: #{e.message}"
  end
  
  def format_phone
    self.phone = Phone.parse(phone).to_s
  end
end
