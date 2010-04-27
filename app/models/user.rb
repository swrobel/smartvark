class User < ActiveRecord::Base
  acts_as_authentic

  has_many :comments
  has_many :opinions
  has_many :redemptions
  has_many :user_audits

end
