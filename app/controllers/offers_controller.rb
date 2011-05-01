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
    @offer = Offer.new(
    :category_id => current_user.category_id,
    :start_date => Time.now,
    :end_date => 1.month.from_now,
    :allow_print => true,
    :allow_mobile => true
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

    respond_to do |format|
      if @offer.save
        flash[:notice] = 'Offer was successfully created.'
        format.html { redirect_to dealdashboard_path }
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
    @offer = Offer.find(params[:id])
    @businesses = current_user.businesses

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        flash[:notice] = 'Offer was successfully updated.'
        format.html { redirect_to dealdashboard_path }
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
    @offer.set_to_archived

    respond_to do |format|
      format.html { redirect_to(dealdashboard_path) }
      format.xml  { head :ok }
    end
  end
end
