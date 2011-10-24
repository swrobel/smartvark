class EmailedOffer < ActiveRecord::Base
  belongs_to :email
  belongs_to :user
end
