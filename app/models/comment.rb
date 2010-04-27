class Comment < ActiveRecord::Base
  acts_as_tree :order => 'id'

  before_create :set_business_id

  belongs_to :offer
  belongs_to :business
  belongs_to :user

  private
  def set_business_id
    self.business_id = offer.business_id
  end
end
