class MController < ApplicationController
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
    render(:partial => 'offers', :collection => Offer.active.find_all_by_category_id(params[:category_id]))
  end

end
