class WelcomeController < ApplicationController
  before_filter :set_current_page, :except => [:undo_last_action, :set_opinion, :sms, :redeem, :shout, :signup, :signin]
  
  skip_filter :set_mobile_format, :only => [:forbusiness, :dealdashboard, :merchant_agreement, :myprofile, :purchase_credits]

  def set_current_page
    session[:user_return_to] = request.fullpath
  end
  
  def index
    raise CanCan::AccessDenied unless can? :read, :index
    if params[:user_id]
      session["devise.invited_by_id"] = params[:user_id].to_i(36)
    elsif params[:user]
      existing_user = User.find_by_email(params[:user][:email])
      if existing_user
        flash[:alert] = "A user with that email has already been registered"
      else
        if session["devise.invited_by_id"]
          existing_user = User.find_by_id(session["devise.invited_by_id"])
          new_user = User.invite!({:email => params[:user][:email], :skip_invitation => true}, existing_user )
        else
          new_user = User.invite!({:email => params[:user][:email], :skip_invitation => true})
        end
        redirect_to accept_invitation_path(new_user, :invitation_token => new_user.invitation_token)
      end
    end
    #if params[:potential]
    #  session[:potential] = false
    #  @potential = Potential.new(params[:potential])
    #  session[:potential] = true if @potential.save
    #end
  end
  
  def dealdashboard
    raise CanCan::AccessDenied unless can? :read, :dealdashboard
    @businesses = current_user.businesses
    @offers = current_user.offers_sorted_for_dealdashboard
  end

  def viewbusiness
    raise CanCan::AccessDenied unless can? :read, :viewbusiness
    @business = Business.find(params[:id])
    raise "Businesses cannot be accessed by ID" unless @business.friendly_id_status.friendly?
  end

  def myprofile
    raise CanCan::AccessDenied unless can? :read, :myprofile
    @user = current_user
    @user.phone = @user.formatted_phone
  end

  def deals
    raise CanCan::AccessDenied unless can? :read, :deals
    
    # Set location based on user's input and display an error if Google can't find it
    if request.post? && params[:location]
      geo_loc = Geocode.create_by_query(params[:location]) rescue nil
      if geo_loc
        cookies.permanent.signed[:geo_location] = Marshal.dump(geo_loc)
      else
        flash[:alert] = "Could not locate #{params[:location]}"
      end
    end
    
    opinions = []
    if params[:kill]
      @likes = []
      session.delete(:likes)
      session.delete(:dislikes)
    else
      @likes = Offer.find_all_by_id(session[:likes])
      opinions += session[:likes] if session[:likes]
      opinions += session[:dislikes] if session[:dislikes]
    end
    
    @out_of_area = false
    loc = geo_location
    if LA.distance_to(loc) > 50
      @out_of_area = true
      @offers = []
    else
      @offers = Offer.select('DISTINCT offers.*').includes([:businesses,:user]).joins(:businesses).where({:businesses => [:id + Business.ids_close_to(loc)]}).active.order(:created_at.desc)
      @offers = @offers.where(:id - opinions) unless opinions.empty?
    end
  end
  
  def mydeals
    raise CanCan::AccessDenied unless can? :read, :mydeals
    @category_id = params[:category_id].blank? ? 1 : Category.find(params[:category_id]).id
    loc = geo_location
    @offers = Offer.select('DISTINCT offers.*').includes([:businesses, :user]).joins(:businesses).where({:businesses => [:id + Business.ids_close_to(loc)]} & (:category_id + Category.subtree_of(@category_id))).active.order(:created_at.desc)
    opinions = current_user.opinions.map(&:offer_id)
    @offers = @offers.where(:id - opinions) unless opinions.empty? || is_mobile_browser?
    @likes = current_user.liked_offers(@category_id)
    redemptions = current_user.redemptions.map(&:offer_id)
    @likes = @likes.where(:id - redemptions) unless redemptions.empty?
  end
  
  def mypicks
    raise CanCan::AccessDenied unless can? :read, :mypicks
    @category_id = params[:category_id].blank? ? 1 : Category.find(params[:category_id]).id
    if current_user
      @likes = current_user.liked_offers(@category_id)
      redemptions = current_user.redemptions.map(&:offer_id)
      @likes = @likes.where(:id - redemptions) unless redemptions.empty?
    else
      @likes = Offer.find_all_by_id(session[:likes])
    end
  end

  def viewdeal
    raise CanCan::AccessDenied unless can? :read, :viewdeal
    @offer = Offer.find(params[:id], :include => [:businesses, :comments])
    raise "Deals cannot be accessed by ID" unless @offer.friendly_id_status.friendly?
  end
  
  def redeem
    raise CanCan::AccessDenied unless can? :read, :redeem
    @offer = Offer.find(params[:id], :include => [:businesses, :offer_type, :redemptions])
    alert = "You have already redeemed this offer" if @offer.offer_type.id == 1 && current_user.redemptions.map(&:offer_id).include?(@offer.id)
    alert = "This deal has reached its redemption limit" if @offer.redemption_limit && @offer.redemptions.count >= @offer.redemption_limit
    alert = "Sorry, this deal is not available for mobile redemption. Please print it from your computer." if !@offer.allow_mobile && is_mobile_browser?
    alert = "Deals cannot be accessed by ID" unless @offer.friendly_id_status.friendly?
    if alert
      flash[:alert] = alert
      redirect_to session[:user_return_to]
    else
      current_user.set_opinion(@offer.id, true) unless current_user.opinions.map(&:offer_id).include?(@offer.id)
      current_user.redemptions.build(offer_id: @offer.id) unless current_user.redemptions.map(&:offer_id).include?(@offer.id)
      current_user.save!
      render :layout => false unless is_mobile_browser?
    end
  end

  def search
    raise CanCan::AccessDenied unless can? :read, :search
    @category_id = params[:category_id].blank? ? 1 : Category.find(params[:category_id]).id
    cat = @category_id
    terms = '%' + params[:search_terms] + '%'
    loc = Geocode.create_by_query(params[:location]) if params[:location] rescue nil
    loc ||= geo_location
    
    @offers = Offer.active.joins(:businesses).joins(:category).where(
                (:category_id + Category.subtree_of(cat)) &
                {:businesses => [:id + Business.ids_close_to(loc)]} &
                (
                  (:title =~ terms) |
                  {:businesses => [:name =~ terms]} |
                  {:category => [:name =~ terms]} |
                  {:category => [:parent_name =~ terms]}
                )
              ).order(:created_at.desc)
    # Don't include offers that the user has already rated
    if current_user
      opinions = current_user.opinions.map(&:offer_id)
    else
      opinions = []
      opinions += session[:likes] if session[:likes]
      opinions += session[:dislikes] if session[:dislikes]
    end
    @offers = @offers.where(:id - opinions) unless opinions.empty?
  end
  
  def merchant_agreement
    raise CanCan::AccessDenied unless can? :read, :agreement
    if params[:accept] && params[:accept] == "true"
      current_user.contract_accepted_at = Time.now
      current_user.save
      redirect_to dealdashboard_path
    end
  end
  
  def purchase_credits
    raise CanCan::AccessDenied unless can? :read, :purchase_credits
    @offer = Offer.find(session[:pending_offer_id], :include => [:businesses]) if session[:pending_offer_id]
  end
  
  def paypal_return
    raise CanCan::AccessDenied unless can? :read, :purchase_credits
    @offer = Offer.find(session[:pending_offer_id], :include => [:businesses]) if session[:pending_offer_id]
    flash[:notice] = "Your account now has " + current_user.credits + " credits"
    if @offer
      redirect_to edit_offer_path(@offer.id)
    else
      redirect_to dealdashboard_path
    end
  end

  def undo_last_action
    @offer_id = 0
    if current_user
      opinion = current_user.opinions.order(:updated_at).last
      @offer_id = opinion.offer_id
      opinion.delete
    else
      if params[:liked] == "1"
        @offer_id = session[:likes].pop
      else
        @offer_id = session[:dislikes].pop
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
      current_user.set_opinion(@offer.id, @liked)
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
    @offer = Offer.find(params[:id], :include => :commenters )

    unless @offer.commenters.include?(current_user)
      params[:comment][:offer_id] = @offer.id
      params[:comment][:user_id] = current_user.id

      @offer.comments.create(params[:comment])
    end
    redirect_to viewdeal_path(@offer.to_param)
  end
  
  def mobile_filter
    @offers = Offer.active.find_all_by_category_id(params[:category_id])
    respond_to do |format|
      format.js
    end
  end
  
  def sms
    @offer = Offer.find(params[:id])
    if current_user.phone.present?
      msg = @offer.title + " " + redeem_url(@offer)
      sms = Moonshado::Sms.new(current_user.phone, msg)
      sms.deliver_sms
    end
    redirect_to viewdeal_path(@offer)
  end
  
  def leads
    if params[:q]
      @lead = params[:q]
    end
    render :layout => false
  end
end
