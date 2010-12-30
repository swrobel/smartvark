class Opinion < ActiveRecord::Base
  scope :likes, :conditions => {:liked => true}
  scope :unlikes, :conditions => {:liked => false}

  belongs_to :user
  belongs_to :offer
end
