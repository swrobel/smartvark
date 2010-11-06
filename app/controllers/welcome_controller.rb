class WelcomeController < ApplicationController
  include Geokit::Geocoders
  RADIUS=50

  helper_method :location

  after_filter :init_user_session
  before_filter :authenticated?, :only => [ :mydeals, :dealdashboard, :myprofile ]
  before_filter :redirect_if_logged_in,  :only => [ :deals, :index ]

  def redirect_if_logged_in
    if logged_in?
      if current_user.business?
        redirect_to dealdashboard_url
      else
        redirect_to mydeals_url
      end
    end
  end

  def dealdashboard
    @businesses = current_user.businesses
    @business = current_user.businesses.first || current_user.businesses.build

    @offers = current_user.offers_sorted_for_dealdashboard
  end

  def filter_deals
    business_ids = params[:business_ids].map(&:to_i) rescue []
    @offers = current_user.offers_sorted_for_dealdashboard(business_ids)
    render :partial => 'deal_on_dashboard'
  end

  def printdeal
    @offer = Offer.find params[:id]
  end

  def viewbusiness
    @business = Business.find(params[:id])
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)

      coordinates = [ @business.lat, @business.lng]
    gmarker = GMarker.new(
      coordinates,
      :title => @business.try(:name),
      :info_window => @business.try(:name)
    )
    @map.overlay_init(gmarker)
    @map.center_zoom_init(coordinates,14)
  end

  def myprofile
    @user = current_user
  end

  def deals
    if request.post?
      cookies[:location] = params[:location] if params[:location]
    end

    if location
      @offers = Offer.active.all(:conditions => { :business_id => close_business_ids })
    else
      @offers = Offer.active
    end

    if session[:liked].blank? || params[:kill]
      session[:user] = User.new
      session[:liked] = []
    end

    @likes = Offer.find_all_by_id(session[:liked])
  end

  def viewdeal
    @offer = Offer.find(params[:id], :include => [ :business, :comments ])
  end

  def search
    @offers = Offer.search(params)

    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    coordinates =  []
    @offers.each do |offer|
      coordinates = [ offer.business.try(:lat), offer.business.try(:lng)]
      gmarker = GMarker.new(
        coordinates,
        :title => offer.business.try(:name),
        :info_window => offer.lead)
      @map.overlay_init(gmarker)
    end
    @map.center_zoom_init(coordinates,14)
  end

  def close_business_ids
    # business_ids = Business.all(:select => 'id', :origin => location, :within => RADIUS)  #TODO:  Sqlite not map supported
    @close_business_ids ||= Business.all(:select => 'id')
  end

  def mydeals
    session.delete(:liked)
    category_id = params[:category_id].to_i
    if (category_id <= 1)
      @likes = current_user.likes_offers[0,7]
      @offers = Offer.active.all(:conditions => { :business_id => close_business_ids })
    else
      @likes = current_user.likes_offers(category_id)[0,7]
      @offers = Offer.active.all(:conditions => { :category_id => category_id,
                            :business_id => close_business_ids  })
    end
  end

  def set_opinion
    if current_user
      current_user.set_opinion(params)
      current_user.save
    else
      session[:user] ||= User.new
      session[:user].set_opinion(params)
    end

    offer= Offer.find params[:offer_id]
    render :update do |page|
      if params[:liked]=='true'


        session[:liked] << params[:offer_id] unless current_user

        if session[:liked] && (session[:liked].length % 3 == 0 )
          page << "jQuery('#signup-popup').modal();"
        end

        page.insert_html :top, 'my_list', list_offer(offer)
      end

      page << "Effect.Shrink('offer_#{offer.id}');"

    end
  end

  def set_location
    cookies[:location] = { :value => params[:location], :expires => 1.day.from_now }
  end

  def location
    (cookies[:location] ||= 'Los Angeles, CA').to_str
  end

  def shout
    @offer = Offer.find(params[:id], :include => [ :business, :commenters ])

    unless @offer.commenters.include?(current_user)
      params[:comment][:offer_id] = @offer.id
      params[:comment][:business_id] = @offer.business_id
      params[:comment][:user_id] = current_user.id

      @offer.comments.create(params[:comment])
    end
    redirect_to :viewdeal, :id => @offer
  end


  private

  def init_user_session
    @user_session = UserSession.new
  end

  def authenticated?
    unless logged_in?
      redirect_to deals_url
    end
  end

end
