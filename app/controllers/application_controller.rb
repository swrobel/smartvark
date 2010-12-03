# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ActiveDevice
  skip_before_filter :set_mobile_format # instead of requiring mobile pages to be .mobile.erb use .html.erb
  before_filter :mobile_redirect # check for mobile browser and redirect to mobile page

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?, :location

  after_filter :log_user

  protected
  
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

  private
  
  def after_sign_in_path_for(resource)
    logger.info "YOU WERE @ " + stored_location_for(:user).to_s
    redirect_to stored_location_for(:user) || root_path
  end

  def mobile_redirect
    # only redirect to mobile site if mobile browser detected and not already on mobile site
    if is_mobile_browser? && !(request.request_uri+"/").include?("/m/")
      redirect_to "/m" + request.request_uri
    end
  end
  
  def logged_in?
    current_user
  end

  def log_user
    current_user && current_user.user_audits.create(:request => params)
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

end
