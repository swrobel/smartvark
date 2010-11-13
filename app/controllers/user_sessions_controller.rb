class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    session.clear
    logger.info params[:user_session].inspect
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Login successful!"
        redirect_to @user_session.record.business? ? dealdashboard_url : mydeals_url
      else
        flash[:notice] = 'Error with username and/or password'
        redirect_to deals_url
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to deals_url
  end
end
