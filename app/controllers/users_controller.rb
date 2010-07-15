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

    if @user.update_attributes(params[:user])
      handle_session_stuffs

      flash[:notice] = "Account registered!"
      UserSession.new(params[:user])
      redirect_to mydeals_url
    else
      #render :action => :new  TODO: Are you sure?
      redirect_to new_user_path
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
      #redirect_to account_url
      redirect_to myprofile_url
    else
      #render :action => :edit
      render :controller => 'welcome', :action => :myprofile
    end
  end
end
