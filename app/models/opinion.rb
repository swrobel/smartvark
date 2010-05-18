class Opinion < ActiveRecord::Base
  named_scope :likes, :conditions => {:liked => true}, :order => 'created_at DESC'
  named_scope :unlikes, :conditions => {:liked => false}, :order => 'created_at DESC'

  belongs_to :user
  belongs_to :offer
end
