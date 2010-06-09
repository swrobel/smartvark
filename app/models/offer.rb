class Offer < ActiveRecord::Base

  belongs_to :category
  belongs_to :business

  has_many :comments
  has_many :redemptions

  has_many :opinions
  has_many :users, :through => :opinions

  has_many :likes,
    :class_name => 'Opinion',
    :conditions => { :liked =>true }

  has_many :dislikes,
    :class_name => 'Opinion',
    :conditions => { :liked => false }


  has_attached_file :coupon, :whiny_thumbnails => true

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
        args << options[:location].to_i
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

    if options[:search_terms]
      conditions <<  'lead like ?'
      args << "%#{options[:search_terms]}%"
    end

    Offer.all(:conditions => [ conditions.join(' AND '), *args ], :include => [:business ], :limit => LIMIT)
  end




end
