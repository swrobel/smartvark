class WelcomeController < ApplicationController
  helper_method :geo_location
  
  before_filter :set_current_page

  def set_current_page
    session[:user_return_to] = request.url
  end
  
  def dealdashboard
    raise CanCan::AccessDenied unless can? :read, :dealdashboard
    @businesses = current_user.businesses

    @offers = current_user.offers_sorted_for_dealdashboard
  end

  def printdeal
    raise CanCan::AccessDenied unless can? :read, :viewdeal
    @offer = Offer.find params[:id]
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
    if request.post?
      cookies[:geo_location] = params[:location] if params[:location]
    end

    if geo_location
      @offers = Offer.select('DISTINCT offers.*').includes([:businesses,:users]).joins(:businesses).where("businesses.id" => close_business_ids).where("archived" => false).where("draft" => false).order('offers.created_at DESC')
    else
      @offers = Offer.active.includes([:businesses, :users])
    end

    if session[:liked].blank? || params[:kill]
      session[:user] = User.new
      session[:liked] = []
    end

    @likes = Offer.find_all_by_id(session[:liked])
  end

  def viewdeal
    raise CanCan::AccessDenied unless can? :read, :viewdeal
    @offer = Offer.find(params[:id], :include => [ :businesses, :comments ])
  end

  def search
    raise CanCan::AccessDenied unless can? :read, :search
    @offers = Offer.search(params)
  end

  def mydeals
    raise CanCan::AccessDenied unless can? :read, :mydeals
    session.delete(:liked)
    category_id = params[:category_id].to_i
    if geo_location
      @offers = Offer.select('DISTINCT offers.*').includes([:businesses,:users]).joins(:businesses).where("businesses.id" => close_business_ids).active.order('offers.created_at DESC')
    else
      @offers = Offer.active.includes([:businesses, :users])
    end
    @likes = current_user.likes_offers[0,7]
    #if (category_id <= 1)
    #  @likes = current_user.likes_offers[0,7]
    #  @offers = Offer.active.where(:business_id => close_business_ids)
    #else
    #  @likes = current_user.likes_offers(category_id)[0,7]
    #  @offers = Offer.active.all(:conditions => { :category_id => category_id,
    #                        :business_id => close_business_ids  })
    #end
  end

  def undo_last_action
    if current_user
      current_user.opinions.find_by_offer_id(params[:offer_id]).delete
    elsif session[:user]
      session[:user].opinions.last.delete
    end

    respond_to do |format|
      format.js
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

    @liked=params[:liked]
    @offer=Offer.find params[:offer_id]
    @prompt_signup=false
    respond_to do |format|
      if @liked
        session[:liked] << params[:offer_id] unless current_user

        if (session[:liked] && session[:liked].length % 3 == 0 )
          @prompt_signup=true
        end
      end
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
