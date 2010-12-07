class BusinessesController < ApplicationController
  # GET /businesses
  # GET /businesses.xml
  #
  before_filter :set_user
  before_filter :set_current_page

  def set_current_page
    session[:user_return_to] = request.url
  end

  def index
    @businesses = Business.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @businesses }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @business = Business.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.xml
  def new
    @businesses = current_user.try(:businesses) || []
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
    @businesses = current_user.businesses
    @business = current_user.businesses.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @business = current_user.businesses.build(params[:business])
    @businesses = current_user.try(:businesses) || []

    respond_to do |format|
      if @business.save
        flash[:notice] = 'Business was successfully created.'
        format.html { redirect_to new_business_path }
        format.xml  { render :xml => @business, :status => :created, :location => @business }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    @business = current_user.businesses.find(params[:id])
    @businesses = current_user.try(:businesses) || []

    respond_to do |format|
      if @business.update_attributes(params[:business])
        flash[:notice] = 'Business was successfully updated.'
        format.html { redirect_to(edit_business_path(@business.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.xml
  def destroy
    @business = Business.find(params[:id])
    @business.destroy

    respond_to do |format|
      format.html { redirect_to(businesses_url) }
      format.xml  { head :ok }
    end
  end

  def set_user
    @user = current_user || User.new
  end

end
