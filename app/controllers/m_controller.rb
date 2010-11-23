class MController < ApplicationController
  layout 'mobile'
  before_filter :authenticated?, :only => [ :redeem ]
  def index
  end

  def deals
    if request.post?
      set_location if params[:location]
    end

    if location
      @offers = Offer.active.all(:conditions => { :business_id => close_business_ids })
    else
      @offers = Offer.active
    end
  end

  def mypicks
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

  def viewbusiness
    @business = Business.find(params[:id])
  end

  def search_results
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

  def searchresults
  end

  def redeem
    @offer = Offer.find params[:id]
  end

  def viewdeal
    @offer = Offer.find(params[:id], :include => [ :business, :comments ])
  end

  def mobile_filter
    @offers = Offer.active.find_all_by_category_id(params[:category_id])
    respond_to do |format|
      format.html #if you don't like, you could delete this line
      format.js # auto call cities/show.js.erb
    end
  end

  def authenticated?
    unless logged_in?
      redirect_to index
    end
  end
end
