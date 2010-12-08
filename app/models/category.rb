class Category < ActiveRecord::Base
  acts_as_tree :order => 'name'

  scope :all_parents, :conditions => { :parent_id => nil }, :order => :name

  has_many :offers

  has_and_belongs_to_many :users

  def to_param
    "#{id}-#{CGI.escape(name)}"
  end

  def self.all_except(list)
    all :conditions => [ 'name not in (?)', list ]
  end
  
  def self.children_of(id)
    other = Category.new(:name=>"Other")
    other.id = id
    self.all(:conditions => {:parent_id => id}, :order => :name) << other
  end

  def clever_or_name
    clever_name.blank? ? name : clever_name
  end
  
  def parent_or_id
    parent_id.nil? ? id : parent_id
  end
end
