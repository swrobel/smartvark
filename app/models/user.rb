class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :encryptable, :encryptor => :authlogic_sha512#, :omniauthable
  
  attr_accessible :email, :password, :password_confirmation

  has_many :comments
  has_many :opinions
  has_many :all_opinions, :class_name => 'Opinion'

  has_many :redemptions
  has_many :user_audits

  has_and_belongs_to_many :categories

  has_many :businesses

  has_attached_file :logo,
    :styles => { :thumb => ["120x120>", :png], :full => ["320x200>", :png] },
    :default_style => :full,
    :whiny_thumbnails => true,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "/logos/:id/:style/:filename"

  def name_or_email
    name.blank? ? email : name
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
    Offer.active.all(
      :conditions => { :business_id => these_business_ids },
      :include => [ :business ],
      :order => "businesses.name, offers.expiry_datetime") +
    Offer.draft.all(
      :conditions => { :business_id => these_business_ids },
      :include => [ :business ],
      :order => "businesses.name, offers.expiry_datetime") +
    Offer.archived.all(
      :conditions => { :business_id => these_business_ids },
      :include => [ :business ],
      :order => "businesses.name, offers.expiry_datetime")

  end
end
