class Category < ActiveRecord::Base
  acts_as_tree

  default_scope :order => 'name'
  named_scope :parents, :conditions => { :parent_id => nil }

  has_many :offers


  def to_param
    "#{id}-#{CGI.escape(name)}"
  end
end
