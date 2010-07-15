class User < ActiveRecord::Base
  acts_as_authentic

  has_many :comments
  has_many :opinions
  has_many :redemptions
  has_many :user_audits

  before_validation :set_email, :on => :create

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
    @likes_offers = opinions.likes.collect(&:offer)
  end
end
