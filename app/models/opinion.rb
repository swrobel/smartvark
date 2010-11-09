class Opinion < ActiveRecord::Base
  scope :likes, :conditions => {:liked => true}, :order => 'created_at DESC'
  scope :unlikes, :conditions => {:liked => false}, :order => 'created_at DESC'

  belongs_to :user
  belongs_to :offer
end
