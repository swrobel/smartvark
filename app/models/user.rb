class User < ActiveRecord::Base
  ROLES = %w[admin business user]
  
  acts_as_geocodable :address => {:street => :address, :locality => :city, :region => :state, :postal_code => :zipcode}
  
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address, :city, :state, :zipcode, :phone, :category_id, :category_ids, :logo, :opinions, :skip_invitation, :facebook_user

  belongs_to :category
  has_many :businesses
  has_many :offers
  has_many :comments
  has_many :opinions
  has_many :likes,
    :class_name => 'Opinion',
    :conditions => { :liked => true }
  has_many :dislikes,
    :class_name => 'Opinion',
    :conditions => { :liked => false }
  has_many :redemptions
  has_many :user_audits
  has_many :transactions
  has_and_belongs_to_many :categories

  has_attached_file :logo,
    :styles => { :thumb => ["120x120>", :png], :full => ["320x200>", :png] },
    :default_style => :full,
    :whiny_thumbnails => true,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "/logos/:id/:style/:filename"
    
  nilify_blanks
  before_save :format_phone
  
  validates :phone, :phone_format => {:allow_blank => true}
  
  def formatted_phone
    Phoner::Phone.parse(phone).format(:us) unless phone.blank?
  end

  def name_or_email
    name.blank? ? email : name.split.first
  end

  def profile_progress
    pp = 10
    pp += 10 unless name.blank?
    pp += 15 unless geocode.blank?
    pp += 15 unless phone.blank?
    pp += 25 unless categories.count < 10
    #pp += 25 unless shares < 3
    return pp
  end
  
  def profile_next_step
    if name.blank?
      "add name (+10%)"
    elsif geocode.blank?
      "add location (+15%)"
    elsif phone.blank?
      "add phone num (+15%)"
    elsif categories.count < 10
      "add 10 tastes (+25%)"
    #elsif shares < 3
    #  "share 3 deals (+25%)"
    else
      "&nbsp;".html_safe
    end
  end
  
  def set_opinion(offer_id, liked)
    self.opinions.build(offer_id: offer_id, liked: liked)
  end

  def liked_offers(category=1)
    Offer.active.joins(:opinions).where((:category_id + Category.subtree_of(category)) & {:opinions => [:id + like_ids]})
  end

  def offers_sorted_for_dealdashboard(other_business_ids=nil)
    Offer.select('DISTINCT offers.*').includes([:businesses, :opinions, :redemptions]).joins(:businesses).where({:businesses => [:user_id >> id]}).order([:archived, :draft, :title])
  end
  
  def paypal_encrypted(return_url, notify_url, num_credits, price, description)  
    allow_quantity_change = (num_credits == 1 ? 1: 0) # only allow if buying one credit
    values = {  
      :business => "stefan_1307486076_biz@smartvark.com",
      :cmd => "_xclick",
      :no_shipping => 1,
      :return => return_url,
      :email => email,
      :custom => id,
      :notify_url => notify_url,
      :cert_id => "RW8PPYNCB6UF6",
      :amount => price,
      :item_name => description,
      :quantity => num_credits,
      :undefined_quantity => allow_quantity_change
    }
   
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_PAYPAL_CERT), OpenSSL::PKey::RSA.new(APP_PAYPAL_KEY, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)  
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")   
  end
  
  def self.find_for_facebook_oauth(data, signed_in_resource=nil)
    if user = User.find_by_email(data["email"])
      user
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      session[:likes].each { |id| user.opinions.build(:offer_id => id, :liked => true) } if session[:likes]
      session[:dislikes].each { |id| user.opinions.build(:offer_id => id, :liked => false) } if session[:dislikes]
      if data = session["devise.facebook_data"]
        user.email = data["email"]
        user.name = data["name"]
        user.gender = data["gender"].first unless data["gender"].blank?
        user.city = data["location"]["name"] unless data["location"].blank?
        #if data["address"]
        #  user.address = data["address"]["street"] unless data["address"]["street"].blank?
        #  user.city = data["address"]["city"] unless data["address"]["city"].blank?
        #  user.state = data["address"]["state"] unless data["address"]["state"].blank?
        #  user.zipcode = data["address"]["zip"] unless data["address"]["zip"].blank?
        #end
        #user.phone = "+" + data["mobile_phone"] unless data["mobile_phone"].blank?
        user.birthday = data["birthday"]
        user.password = Devise.friendly_token[0,20]
        user.invited_by_id = session["devise.invited_by_id"]
        user.invited_by_type = "User"
        user.facebook_user = true
      end
    end
  end
  
  def update_with_password(params={})
    params.delete(:password) if params[:password].blank? 
    params.delete(:password_confirmation) if params[:password_confirmation].blank?
    update_attributes(params) 
  end

private

  def format_phone
    self.phone = Phoner::Phone.parse(phone).to_s unless phone.blank?
  end
end
