class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def handle_session_stuffs
    session.delete(:user)
  end

  def create
    @user = session[:user] || User.new
    @user.attributes = params[:user]

    unless @user.valid?
      @user.errors.each_full { |msg| logger.info msg }
    end

    if @user.save
      handle_session_stuffs  unless params[:user][:type]

      flash[:notice] = "Account registered!"
      UserSession.new(params[:user])
      redirect_to @user.business? ? mydeals_url : new_business_path
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to @user.business? ? new_business_path : myprofile_path
    else
      #render :action => :edit
      render :controller => 'welcome', :action => :myprofile
    end
  end

  private

end
