class Category < ActiveRecord::Base
  acts_as_tree :order => 'name'

  named_scope :all_parents, :conditions => { :parent_id => nil }, :order => :id

  has_many :offers

  has_and_belongs_to_many :users

  def to_param
    "#{id}-#{CGI.escape(name)}"
  end

  def self.all_except(list)
    all :conditions => [ 'name not in (?)', list ]
  end

  def clever_or_name
    clever_name.blank? ? name : clever_name
  end
end
