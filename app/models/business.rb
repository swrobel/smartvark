class Business < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  acts_as_geocodable :address => {:street => :address, :locality => :city, :region => :state, :postal_code => :zipcode}
  
  belongs_to :user
  has_and_belongs_to_many :offers

  nilify_blanks :before => :validation
  before_validation :get_yelp_data
  before_save :format_phone
  
  HUMANIZED_ATTRIBUTES = {
    :name => "Location name",
    :short_name => "Nickname",
    :address => "Address 1",
    :zipcode => "Zip"
  }

  validates :name, :presence => true
  validates :short_name, :length => { :maximum => 20 }
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zipcode, :presence => true
  validates :phone, :phone_format => true
  
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def self.ids_close_to(loc)
    Business.origin(loc, :within => 25).order("distance").collect {|x| x.id}
  end
  
  def formatted_phone
    Phoner::Phone.parse(phone).format(:us) unless phone.blank?
  end

  def short_or_name
    short_name.blank? ? name : short_name
  end

  def city_state_zip
    [city, state].join(', ') << ' ' << zipcode
  end

  def address_as_string
    [ address, city_state_zip].join(', ')
  end

  def facebook_link
    return if facebook_url.blank?
    if facebook_url.include?('facebook.com/')
      facebook_url
    else
      'http://facebook.com/' + facebook_url
    end
  end
  
  def twitter_link
    return if twitter_url.blank?
    if twitter_url.include?('twitter.com/')
      twitter_url
    else
      'http://twitter.com/' + twitter_url
    end
  end
  
  def yelp_link
    return if yelp_url.blank?
    if yelp_url.include?('yelp.com/')
      yelp_url
    else
      'http://yelp.com/biz/' + yelp_url
    end
  end

private

  def get_yelp_data
    return if yelp_url.blank? || !name.blank?
    self.yelp_url = yelp_url.split("#").first
    consumer = OAuth::Consumer.new(YELP_CONSUMER_KEY, YELP_CONSUMER_SECRET, {:site => "http://api.yelp.com"})
    access_token = OAuth::AccessToken.new(consumer, YELP_TOKEN, YELP_TOKEN_SECRET)
    
    path = "/v2/business/" + yelp_url.split("/").last
    result = access_token.get(path).body
    result = Yajl::Parser.parse(result)
    
    self.yelp_mobile_url = result["mobile_url"]
    self.yelp_rating_img_url = result["rating_img_url"]
    self.yelp_review_count = result["review_count"]
    self.name = result["name"] if name.blank?
    self.phone = result["phone"] if phone.blank?
    location = result["location"]
    self.address = location["address"][0] if address.blank?
    self.address_2 = location["address"][1] if address_2.blank?
    self.city = location["city"] if city.blank?
    self.state = location["state_code"] if state.blank?
    self.zipcode = location["postal_code"] if zipcode.blank?
  rescue Exception => e
    logger.info "Yelp failure: #{e.message}"
  end
  
  def format_phone
    self.phone = Phoner::Phone.parse(phone).to_s unless phone.blank?
  end
end
