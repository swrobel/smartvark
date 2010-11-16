class MController < ApplicationController
  layout 'mobile'
  def index
  end

  def deals
  end

  def mypicks
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

  def viewbusiness
  end

  def viewdeal
  end

  def mobile_filter
    @offers = Offer.active.find_all_by_category_id(params[:category_id])
    respond_to do |format|
      format.html #if you don't like, you could delete this line
      format.js # auto call cities/show.js.erb
    end
  end
end
