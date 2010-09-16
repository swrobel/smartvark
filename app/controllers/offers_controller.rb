class OffersController < ApplicationController

  before_filter :require_user
  # GET /offers
  # GET /offers.xml
  def index
    @offers = Offer.all

    respond_to do |format|
      format.html # index.html.erb
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
    @business = Business.new  #TODO: Set to incoming business
    @offer = Offer.new(
    :lead => 'Save Big on Our 50% off Fall Sale!',
    :description => "You'll find a wide variety of great fall fashions on sale from now until September 1st. Bring a friend and get an additional 10% off.",
    :exclusivity_text => 'Offer valid Monday-Thursday. Not valid with any other offers.',
    :redemption_code => "HALFOFFJULY2010",
    :expiry_datetime => 1.month.from_now
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
    @business = @offer.business
    @businesses = current_user.businesses
  end

  # POST /offers
  # POST /offers.xml
  def create

    @offer = Offer.create_many_by_user_and_params(current_user, params[:offer])

    respond_to do |format|
      if @offer
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

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        flash[:notice] = 'Offer was successfully updated.'
        format.html { redirect_to(@offer) }
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
    @offer.update_attribute(:archived, true)

    respond_to do |format|
      format.html { redirect_to(dealdashboard_url(:id => @offer.business_id)) }
      format.xml  { head :ok }
    end
  end
end
