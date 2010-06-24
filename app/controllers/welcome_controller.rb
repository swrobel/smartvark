class WelcomeController < ApplicationController
  include Geokit::Geocoders

  helper_method :location

  after_filter :init_user_session
  before_filter :authenticated?, :only => [ :mydeals, :dealdashboard ]
  before_filter :redirect_if_logged_in,  :only => [ :deals, :index ]

  def redirect_if_logged_in
    if logged_in?
      redirect_to mydeals_url
    end
  end

  def dealdashboard
    #TODO : Make this the owners business  check config/routes
    #@business = current_user.business
    @business = Business.find(params[:id])
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
    @offers = Offer.all
    if session[:liked].blank? || params[:kill]
      session[:liked] = []
    end

    @likes = Offer.find_all_by_id(session[:liked])
  end

  def viewdeal
    @offer = Offer.find(params[:id])
  end

  def search
    @offers = Offer.search(params)

    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    coordinates =  []
    @offers.each do |offer|
      coordinates = [ offer.business.lat, offer.business.lng]
      gmarker = GMarker.new(
        coordinates,
        :title => offer.business.try(:name),
        :info_window => offer.lead)
      @map.overlay_init(gmarker)
    end
    @map.center_zoom_init(coordinates,14)
  end

  def mydeals
    session.delete(:liked)
    category_id = params[:category_id].to_i
    @offers = begin
                if (category_id <= 1)
                  Offer.all
                else
                  Offer.find_all_by_category_id(category_id)
                end
              end

    @likes = current_user.likes_offers[0,7]
  end

  def set_opinion
    if current_user
      current_user.set_opinion(params)
      current_user.save
    else
      session[:user] = User.new
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
