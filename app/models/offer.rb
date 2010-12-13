class Offer < ActiveRecord::Base
  scope :active, where(:archived => false).where(:draft => false).order('created_at DESC')
  scope :draft, where(:archived => false).where(:draft => true).order('created_at DESC')
  scope :archived, where(:archived => true).where(:draft => false).order('created_at DESC')

  HUMANIZED_ATTRIBUTES = {
    :allow_mobile => "",
    :businesses => "",
    :lead => "Title"
  }
  
  validates :offer_type, :presence => true
  validates :category_id, :presence => true
  validates :lead, :presence => true
  validates :offer_active_on, :presence => true
  validates :expiry_datetime, :presence => true
  validates :businesses, :presence => {:message => "You must select at least one location for this offer"}
  validates :allow_mobile, :presence => {:unless => "allow_print", :message => "You must allow print, mobile or both redemption types"}
  
  belongs_to :category
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

  before_update :unarchive_if_draft_or_activated

  def set_to_archived
    @do_not_unarchive=true
    update_attribute(:archived,true)
  end

  def coupon
    businesses.first.user.logo
  end

  LIMIT = 5

  def to_param
    "#{id}-#{URI.escape(CGI.escape(lead),'.')}"
  end

  def self.search(options = {})
    # TODO Refactor with merge_conditions
    conditions = []
    args = []

    if (category = options[:category_id].to_i) > 1
      conditions << 'category_id = ?'
      args << category
    end

    unless options[:location].blank?
      if options[:location] =~ /\d{5}/
        conditions << 'businesses.postal_code = ?'
        args << options[:location]
      else
        city, state = options[:location].split(/,/,2)
        if city
          conditions << 'lower(businesses.city) = ?'
          args << city.strip.downcase
        end

        if state
          conditions << 'lower(businesses.state) = ?'
          args << state.strip.downcase
        end
      end
    end

    unless options[:user_admin]
      conditions << "archived <> ?"
      conditions << "draft <> ?"
      args << true << true
    end

    if options[:search_terms]
      conditions <<  '(lead like ? OR businesses.name like ?)'
      2.times { args << "%#{options[:search_terms]}%" }
    end
    Offer.all(:conditions => [ conditions.join(' AND '), *args ],
              :include => [:businesses ], :limit => LIMIT)

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
    ((expiry_datetime < Date.today) rescue false)
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
    connection.execute("update offers set archived = true where expiry_datetime <= current_date")
  end

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
