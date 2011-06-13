class Transaction < ActiveRecord::Base
  belongs_to :user
  serialize :params
  
  after_create :apply_credits_to_user
  
private
  def apply_credits_to_user
    if status == "Completed"
      user.credits += credits
      user.save
    end
  end
end