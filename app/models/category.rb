class Category < ActiveRecord::Base
  acts_as_tree :order => 'id DESC'

  default_scope :order => 'name'
  named_scope :parents, :conditions => { :parent_id => nil }, :order => :id

  has_many :offers


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
