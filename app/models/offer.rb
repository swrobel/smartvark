class Offer < ActiveRecord::Base
  belongs_to :category
  has_many :comments
  belongs_to :business

  has_attached_file :coupon, :whiny_thumbnails => true
end
