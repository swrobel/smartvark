class Offer < ActiveRecord::Base
  belongs_to :category
  has_many :comments
  belongs_to :business
end
