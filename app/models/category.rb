class Category < ActiveRecord::Base
  has_friendly_id :clever_or_name, :use_slug => true
  has_ancestry :cache_depth => true

  scope :all_parents, to_depth(1)

  has_many :offers
  has_many :users
  has_and_belongs_to_many :users

  def clever_or_name
    clever_name.blank? ? name : clever_name
  end
  
  def parent_or_id
    # Only return parent_id for those that aren't children of All
    parent_id.nil? || parent_id == 1 ? id : parent_id
  end
end
