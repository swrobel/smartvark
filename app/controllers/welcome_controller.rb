class WelcomeController < ApplicationController
  include Geokit::Geocoders

  helper_method :location

  after_filter :init_user_session
  before_filter :authenticated?, :only => [ :mydeals]
  before_filter :redirect_if_logged_in,  :only => [ :deals, :index ]

  def redirect_if_logged_in
    if logged_in?
      redirect_to mydeals_url
    end
  end

  def deals
    if request.post?
      cookies[:location] = params[:location] if params[:location]
    end
    session[:liked] = 0
    @offers = Offer.all
  end

  def viewdeal
    @offer = Offer.find(params[:id])
  end

  def search
    @offers = Offer.search(params)

    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init(coordinates,14)
    @offers.each do |offer|
      gmarker = GMarker.new(
        [ offer.business.lat, offer.business.lng],
        :title => @offer.business.news,
        :info_window => @offer.lead)
      @map.overlay_init(gmarker)
    end
  end

  def mydeals
    session[:liked] = 0
    category_id = params[:category_id].to_i
    @offers = begin
                if (category_id <= 1)
                  Offer.all
                else
                  Offer.find_all_by_category_id(category_id)
                end
              end

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
      page << "Effect.Shrink('offer_#{offer.id}');"
      if params[:liked]=='true'

        page.insert_html :bottom, 'my_list', list_offer(offer)

        session[:liked]+=1
        page << "alert('Time to sign up son!')" if session[:liked] > 2
      end
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
