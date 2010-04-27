class RedemptionsController < ApplicationController
  # GET /redemptions
  # GET /redemptions.xml
  def index
    @redemptions = Redemption.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @redemptions }
    end
  end

  # GET /redemptions/1
  # GET /redemptions/1.xml
  def show
    @redemption = Redemption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @redemption }
    end
  end

  # GET /redemptions/new
  # GET /redemptions/new.xml
  def new
    @redemption = Redemption.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @redemption }
    end
  end

  # GET /redemptions/1/edit
  def edit
    @redemption = Redemption.find(params[:id])
  end

  # POST /redemptions
  # POST /redemptions.xml
  def create
    @redemption = Redemption.new(params[:redemption])

    respond_to do |format|
      if @redemption.save
        flash[:notice] = 'Redemption was successfully created.'
        format.html { redirect_to(@redemption) }
        format.xml  { render :xml => @redemption, :status => :created, :location => @redemption }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @redemption.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /redemptions/1
  # PUT /redemptions/1.xml
  def update
    @redemption = Redemption.find(params[:id])

    respond_to do |format|
      if @redemption.update_attributes(params[:redemption])
        flash[:notice] = 'Redemption was successfully updated.'
        format.html { redirect_to(@redemption) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @redemption.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /redemptions/1
  # DELETE /redemptions/1.xml
  def destroy
    @redemption = Redemption.find(params[:id])
    @redemption.destroy

    respond_to do |format|
      format.html { redirect_to(redemptions_url) }
      format.xml  { head :ok }
    end
  end
end
