class User < ActiveRecord::Base
  ROLES = %w[admin business user]
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address, :city, :state, :zipcode, :phone, :category_id

  belongs_to :category
  has_many :comments
  has_many :opinions
  has_many :redemptions
  has_many :user_audits
  has_many :businesses
  has_and_belongs_to_many :categories

  has_attached_file :logo,
    :styles => { :thumb => ["120x120>", :png], :full => ["320x200>", :png] },
    :default_style => :full,
    :whiny_thumbnails => true,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "/logos/:id/:style/:filename"
    
  nilify_blanks
  
  HUMANIZED_ATTRIBUTES = {
    :phone => "Mobile Phone",
    :zipcode => "Zip"
  }

  def name_or_email
    name.blank? ? email : name.split.first
  end
  
  def set_opinion(params)
    self.opinions.build(:offer_id => params[:offer_id], :liked => params[:liked]=='true')
  end

  def likes_offers(category=nil)
    @likes_offers = opinions.likes.collect(&:offer).delete_if { |b| b.nil? || !b.active? || (category && b.category_id != category) }
  end

  def offers_sorted_for_dealdashboard(other_business_ids=nil)
    these_business_ids = if other_business_ids.nil?
                           business_ids
                         else
                           other_business_ids & business_ids
                         end
    Offer.select('DISTINCT offers.*').includes([:businesses,:likes, :dislikes, :redemptions]).joins(:businesses).where("businesses.id" => these_business_ids).order("offers.archived, offers.draft, offers.title")
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    logger.info data.inspect
    if user = User.find_by_email(data["email"])
      user
    else # Create an user with a stub password. 
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20]) 
    end
  end
  
  def update_with_password(params={})
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end

end
