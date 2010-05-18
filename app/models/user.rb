class User < ActiveRecord::Base
  acts_as_authentic

  has_many :comments
  has_many :opinions
  has_many :redemptions
  has_many :user_audits

  def set_opinion(params)
    self.opinions.build( :offer_id => params[:offer_id],
                        :liked => params[:liked]=='true')
  end

  def likes_offers
    @likes_offers = opinions.likes.collect(&:offer)
  end
end
