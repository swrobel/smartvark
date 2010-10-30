class Offer < ActiveRecord::Base
  named_scope :active, :conditions => {:archived => false, :draft => false}, :order => 'offers.created_at DESC'
  named_scope :draft, :conditions => {:archived => false, :draft => true}, :order => 'offers.created_at DESC'
  named_scope :archived, :conditions => {:archived => true, :draft => false}, :order => 'offers.created_at DESC'

  belongs_to :category
  belongs_to :business

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

#  has_attached_file :coupon, :whiny_thumbnails => true
  def coupon
    business.user.logo
  end

  LIMIT = 5

  def to_param
    "#{id}-#{CGI.escape(lead)}"
  end

  def self.search(options = {})
    # TODO Refactory with merge_conditions
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

    unless params[:user_admin]
      conditions << "archived=false"
      conditions << "draft=false"
    end

    if options[:search_terms]
      conditions <<  '(lead like ? OR businesses.name like ?)'
      2.times { args << "%#{options[:search_terms]}%" }
    end
    Offer.all(:conditions => [ conditions.join(' AND '), *args ],
              :include => [:business ], :limit => LIMIT)

  end

  def self.create_many_by_user_and_params(current_user, params)
    business_ids = params.delete('business_ids')
    unless business_ids.blank?
      current_user.businesses.find(business_ids).each do |business|
        business.offers.create!(params)
      end
    end
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
    ((expiry_datetime < DateTime.now) rescue false)
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
end
