# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ActiveDevice
  skip_before_filter :set_mobile_format # instead of requiring mobile pages to be .mobile.erb use .html.erb
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user, :logged_in?

  after_filter :log_user

 private

  def logged_in?
    current_user
  end

  def log_user
    current_user && current_user.user_audits.create(:request => params)
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to deals_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to mydeals_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def set_location
    cookies[:location] = { :value => params[:location], :expires => 1.day.from_now }
  end

  def location
    (cookies[:location] ||= 'Los Angeles, CA').to_str
  end

  def close_business_ids
    # business_ids = Business.all(:select => 'id', :origin => location, :within => RADIUS)  #TODO:  Sqlite not map supported
    @close_business_ids ||= Business.all(:select => 'id')
  end

end
