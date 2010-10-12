class Comment < ActiveRecord::Base
  acts_as_tree :order => 'id'

  before_create :set_business_id

  belongs_to :offer
  belongs_to :business
  belongs_to :user

  validates_presence_of :text, :user_id


  def commenter
    @commenter ||= begin
      commenter = [user.name.blank? ? user.email.split(/@/,2).first : user.name]
      commenter << user.city
      commenter
                   end
  end

  private
  def set_business_id
    self.business_id = offer.business_id
  end

end
