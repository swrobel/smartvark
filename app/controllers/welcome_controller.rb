class WelcomeController < ApplicationController
  helper_method :geo_location
  
  before_filter :set_current_page, :except => [:undo_last_action, :set_opinion]

  def set_current_page
    session[:user_return_to] = request.fullpath
  end
  
  def dealdashboard
    raise CanCan::AccessDenied unless can? :read, :dealdashboard
    @businesses = current_user.businesses

    @offers = current_user.offers_sorted_for_dealdashboard
  end

  def printdeal
    raise CanCan::AccessDenied unless can? :read, :viewdeal
    @offer = Offer.find(params[:id], :include => :businesses)
    render :layout => false
  end

  def viewbusiness
    raise CanCan::AccessDenied unless can? :read, :viewbusiness
    @business = Business.find(params[:id])
  end

  def myprofile
    raise CanCan::AccessDenied unless can? :read, :myprofile
    @user = current_user
    @user.phone = @user.formatted_phone
  end

  def deals
    raise CanCan::AccessDenied unless can? :read, :deals
    
    logger.info session
    
    # Set location based on user's input and display an error if Google can't find it
    if request.post? && params[:location]
      geo_loc = Geocode.create_by_query(params[:location]) rescue nil
      if geo_loc
        cookies.permanent.signed[:geo_location] = Marshal.dump(geo_loc)
      else
        flash[:alert] = "Could not locate #{params[:location]}"
      end
    end
    
    if params[:kill]
      @likes = []
      session.delete(:likes)
      session.delete(:dislikes)
    else
      @likes = Offer.find_all_by_id(session[:likes])
    end
    
    @out_of_area = false
    if LA.distance_to(geo_location) > 50
      @out_of_area = true
      @offers = []
    else
      @offers = Offer.select('DISTINCT offers.*').includes([:businesses,:users]).joins(:businesses).where({:businesses => [:id + Business.ids_close_to(geo_location)]}).active
      @offers = @offers.where(:id - @likes) unless @likes.empty?
    end
    
    logger.info session
  end
  
  def mydeals
    raise CanCan::AccessDenied unless can? :read, :mydeals
    @category_id = params[:category_id].blank? ? 1 : Category.find(params[:category_id]).id
    @offers = Offer.select('DISTINCT offers.*').includes([:businesses,:users]).joins(:businesses).where("businesses.id" => Business.ids_close_to(geo_location)).active.order('offers.created_at DESC')
    if (@category_id <= 1)
      @likes = current_user.likes_offers
    else
      @likes = current_user.likes_offers(category_id)
    end
  end

  def viewdeal
    raise CanCan::AccessDenied unless can? :read, :viewdeal
    @offer = Offer.find(params[:id], :include => [ :businesses, :comments ])
  end

  def search
    raise CanCan::AccessDenied unless can? :read, :search
    @category_id = params[:category_id].blank? ? 1 : Category.find(params[:category_id]).id
    cat = @category_id
    terms = '%' + params[:search_terms] + '%'
    loc = params[:location].blank? ? geo_location : params[:location]
    
    @offers = Offer.active.joins(:businesses).joins(:category).where(
                (:category_id + Category.subtree_of(cat)) &
                (
                  (:title =~ terms) |
                  {:businesses => [:name =~ terms]} |
                  {:category => [:name =~ terms]}
                )
              )
    # don't include offers that the user has already rated
    if current_user
      opinions = current_user.opinions.collect {|x| x.offer_id}
    else
      opinions = session[:user].opinions.collect {|x| x.offer_id}
    end
    @offers = @offers.where(:id - opinions) unless opinions.empty?
  end

  def undo_last_action
    if current_user
      current_user.opinions.find_by_offer_id(params[:offer_id]).delete
      current_user.save
    else
      if params[:liked] == "1"
        session[:likes].pop
      else
        session[:dislikes].pop
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def set_opinion
    @liked = params[:liked] == "1"
    @offer = Offer.find(params[:offer_id])
    @prompt_signup = false
    session[:likes] ||= []
    session[:dislikes] ||= []
    
    if current_user
      current_user.set_opinion(params)
      current_user.save
    else
      if @liked
        session[:likes] << @offer.id
        @prompt_signup = session[:likes].length % 3 == 0
      else
        session[:dislikes] << @offer.id
      end
    end

    respond_to do |format|
      format.js
    end
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

end
