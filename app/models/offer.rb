class Offer < ActiveRecord::Base
  belongs_to :category
  has_many :comments
  belongs_to :business

  has_attached_file :coupon, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
