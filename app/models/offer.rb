class Offer < ActiveRecord::Base
  has_friendly_id :title, :use_slug => true
  
  attr_protected :user_id
  
  scope :active, lambda {where(:archived => false).where(:draft => false).where(:start_date.lte => Date.today)}
  scope :draft, where(:archived => false).where(:draft => true)
  scope :archived, where(:archived => true).where(:draft => false)
  
  belongs_to :user
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
  has_many :likes,
    :class_name => 'Opinion',
    :conditions => { :liked => true }
  has_many :dislikes,
    :class_name => 'Opinion',
    :conditions => { :liked => false }
  has_many :yipit_rows
  has_many :sqoot_rows
  
  nilify_blanks
  before_update :unarchive_if_draft_or_activated
  
  HUMANIZED_ATTRIBUTES = {
    :businesses => "",
    :new_cust_only => "Limit this offer to new customers only"
  }
  
  validates :offer_type_id, :presence => true
  validates :category_id, :presence => true
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :businesses, :presence => {:message => "You must select at least one location for this offer"}
  validates :redemption_limit, :numericality => {:allow_blank => true}
  validates :allow_print, :presence => {:unless => "allow_mobile", :message => ", allow mobile or both must be selected"}

  def credits_required
    num_locations * num_months
  end
  
  def num_locations
    businesses.size
  end
  
  def num_months
    ((end_date - start_date)/31.0).ceil
  end
  
  def set_to_archived
    @do_not_unarchive=true
    update_attribute(:archived,true)
  end

  def logo
    user.logo
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
    connection.execute("update offers set archived = true, updated_at = now() where id in (select o1.id from offers o1 left join (select o.id, count(r.id) as redemption_count from offers o join redemptions r on o.id = r.offer_id group by o.id) o2 on o1.id = o2.id where archived = false and (coalesce(o2.redemption_count,0) >= o1.redemption_limit or o1.end_date <= current_date))")
  end

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
