class Business < ActiveRecord::Base
  has_many :offers
  has_many :comments
end
