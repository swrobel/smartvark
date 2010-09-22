class User < ActiveRecord::Base
  acts_as_authentic

  has_many :comments
  has_many :opinions
  has_many :all_opinions, :class_name => 'Opinion'

  has_many :redemptions
  has_many :user_audits

  before_validation :set_email, :on => :create

  #######################

  has_many :businesses

  before_validation :set_login

  has_attached_file :logo, :styles => { :thumb => ["120x120>", :png], :full => ["380x160>", :png] }, :default_style => :full, :whiny_thumbnails => true

  def set_login
    self.login ||= email
  end
  #######################

  def set_email
    self.email ||= login
  end

  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    self.persistence_token = reset_persistence_token
    logger.info("HEY FACEBOOK, HOW'S IT GOING? SO LOVELY TO SEE: #{facebook_session.user.name}")
  end

  def set_opinion(params)
    self.opinions.build(:offer_id => params[:offer_id], :liked => params[:liked]=='true')
  end

  def likes_offers
    @likes_offers = opinions.likes.collect(&:offer).delete_if { |b| !b.active? }
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
      :order => "businesses.`name`, offers.`expiry_datetime`") +
    Offer.draft.all(
      :conditions => { :business_id => these_business_ids },
      :include => [ :business ],
      :order => "businesses.`name`, offers.`expiry_datetime`") +
    Offer.archived.all(
      :conditions => { :business_id => these_business_ids },
      :include => [ :business ],
      :order => "businesses.`name`, offers.`expiry_datetime`")

  end
end
