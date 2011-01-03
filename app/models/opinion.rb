class Opinion < ActiveRecord::Base
  scope :likes, where(:liked => true)
  scope :dislikes, where(:liked => false)

  belongs_to :user
  belongs_to :offer
end
