class Opinion < ActiveRecord::Base
  named_scope :likes, :conditions => {:liked => true}
  named_scope :unlikes, :conditions => {:liked => false}
  belongs_to :user
  belongs_to :offer
end
