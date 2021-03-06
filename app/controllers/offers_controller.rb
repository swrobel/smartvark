class OffersController < ApplicationController
  skip_filter :set_mobile_format
  
  load_resource :only => [:edit, :update, :destroy]
  authorize_resource

  # GET /offers
  # GET /offers.xml
  def index
    @offers = Offer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @offers }
    end
  end
  
  def print
    @offers = current_user.offers.active.includes(:businesses).order(:end_date.asc)
    
    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @offers }
    end
  end

  # GET /offers/1
  # GET /offers/1.xml
  def show
    @offer = Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @offer }
    end
  end

  # GET /offers/new
  # GET /offers/new.xml
  def new
    # Force user to fill out profile before creating offer
    if current_user.name.blank? || current_user.businesses.blank?
      flash[:alert] = "Please input Business Name and a Location"
      redirect_to new_business_path and return
    end
    
    @offer = Offer.new(
    :category_id => current_user.category_id,
    :start_date => Time.now,
    :end_date => 1.month.from_now
    )

    @businesses = current_user.businesses

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @offer }
    end
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.find(params[:id])
    @businesses = current_user.businesses
  end

  # POST /offers
  # POST /offers.xml
  def create
    @offer = current_user.offers.build(params[:offer])
    @businesses = current_user.businesses
    
    forced_draft = !@offer.draft && @offer.credits_required > current_user.credits
    @offer.draft = forced_draft
    @offer.credits_used = @offer.credits_required unless @offer.draft

    respond_to do |format|
      if @offer.save
        # Offer has been saved, now deduct appropriate # of credits
        unless @offer.draft
          current_user.credits -= @offer.credits_required
          current_user.save
        end
        
        # Redirect as appropriate
        if forced_draft
          session[:pending_offer_id] = @offer.id
          flash[:alert] = 'Insufficient credits to create offer. Draft saved.'
          format.html { redirect_to purchase_credits_path }
        else
          flash[:notice] = 'Offer was successfully created.'
          format.html { redirect_to dealdashboard_path }
        end
        format.xml  { render :xml => @offer, :status => :created, :location => @offer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /offers/1
  # PUT /offers/1.xml
  def update
    @businesses = current_user.businesses
    @offer = Offer.find(params[:id])
    credits_already_used = @offer.credits_used
    @offer.attributes = params[:offer]
    
    activated = !@offer.draft
    @offer.draft = (@offer.credits_required - @offer.credits_used) > current_user.credits
    @offer.credits_used = @offer.credits_required unless @offer.draft

    respond_to do |format|
      if @offer.save
        # Offer has been updated, now deduct appropriate # of credits
        unless @offer.draft || credits_already_used >= @offer.credits_used
          current_user.credits -= (@offer.credits_used - credits_already_used)
          current_user.save
        end
        
        # Redirect as appropriate
        if @offer.draft && activated
          session[:pending_offer_id] = @offer.id
          flash[:alert] = 'Insufficient credits to update offer. Draft saved.'
          format.html { redirect_to purchase_credits_path }
        else
          flash[:notice] = 'Offer was successfully updated.'
          format.html { redirect_to dealdashboard_path }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.xml
  def destroy
    @offer = Offer.find(params[:id])
    @offer.update_attribute(:archived,true)

    respond_to do |format|
      format.html { redirect_to(dealdashboard_path) }
      format.xml  { head :ok }
    end
  end
end
