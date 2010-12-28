class Offer < ActiveRecord::Base
  has_friendly_id :title, :use_slug => true
  
  scope :active, where(:archived => false).where(:draft => false).order('created_at DESC')
  scope :draft, where(:archived => false).where(:draft => true).order('created_at DESC')
  scope :archived, where(:archived => true).where(:draft => false).order('created_at DESC')
  
  belongs_to :category
  belongs_to :offer_type
  has_and_belongs_to_many :businesses
  has_many :comments
  has_many :commenters,
    :through => :comments,
    :source => :user,
    :class_name => 'User'
  has_many :redemptions
  has_many :opinions
  has_many :users, :through => :opinions
  has_many :likes,
    :class_name => 'Opinion',
    :conditions => { :liked =>true }
  has_many :dislikes,
    :class_name => 'Opinion',
    :conditions => { :liked => false }
  
  nilify_blanks
  before_update :unarchive_if_draft_or_activated
  
  HUMANIZED_ATTRIBUTES = {
    :businesses => ""
  }
  
  validates :offer_type_id, :presence => true
  validates :category_id, :presence => true
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :businesses, :presence => {:message => "You must select at least one location for this offer"}
  validates :redemption_limit, :numericality => {:allow_blank => true}
  validates :allow_print, :presence => {:unless => "allow_mobile", :message => ", allow mobile or both must be selected"}

  def set_to_archived
    @do_not_unarchive=true
    update_attribute(:archived,true)
  end

  def coupon
    businesses.first.user.logo
  end

  def self.search(options = {})
    cat = options[:category_id].to_i

    if options[:location].blank?
      loc = geo_location
    else
      loc = options[:location]
    end

    (Offer.active.where(:category_id => Category.subtree_of(cat)).where(:title.matches => '%'+options[:search_terms]+'%') & Business.origin(loc, :within => 25)).limit(10).order('distance')
  end

  def active?
    !(draft? || archived?)
  end

  def status
    if draft?
      :draft
    elsif archived?
      :archived
    end
  end

  def expired_by_date?
    ((end_date < Date.today) rescue false)
  end

  def expired?
    archived? || expired_by_date?
  end

  def unarchive_if_draft_or_activated
    if archived? && !expired_by_date? && @do_not_unarchive.nil?
      self.archived=false
    end
    true
  end
  
  def self.archive_expired
    connection.execute("update offers set archived = true where end_date <= current_date")
  end

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
