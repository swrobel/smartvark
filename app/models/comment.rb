class Comment < ActiveRecord::Base
  has_ancestry :cache_depth => true

  belongs_to :offer
  belongs_to :user

  validates_presence_of :text, :user_id


  def commenter
    @commenter ||= begin
      commenter = [user.name.blank? ? user.email.split(/@/,2).first : user.name]
      commenter << user.city
      commenter
    end
  end

end
