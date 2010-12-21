# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Geokit::Geocoders
  RADIUS=50
  
  include ActiveDevice::Helper
  skip_before_filter :set_mobile_format # instead of requiring mobile pages to be .mobile.erb use .html.erb
  before_filter :mobile_redirect # check for mobile browser and redirect to mobile page

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?, :geo_location, :home_path

  after_filter :log_user

  protected
  
  def set_location
    cookies[:geo_location] = { :value => params[:location], :expires => 1.day.from_now }
  end

  def geo_location
    (cookies[:geo_location] ||= 'Los Angeles, CA').to_str
  end

  def close_business_ids
    if Rails.env.production?
      business_ids = Business.all(:select => 'id', :origin => location, :within => RADIUS)
    else
      @close_business_ids ||= Business.all(:select => 'id')
    end
  end

  private

  def mobile_redirect
    # only redirect to mobile site if mobile browser detected and not already on mobile site
    if is_mobile_browser? && !(request.fullpath+"/").include?("/m/")
      logger.info "Mobile, brand: " + device_brand.to_s + ", model: " + device_model.to_s + " at " + request.fullpath
      m_path = "/m" + request.fullpath
      Rails.application.routes.recognize_path(m_path, :method => :get)
      redirect_to m_path
    end
  rescue Exception => e
    logger.info e.message
  end

  def log_user
    if current_user && params[:controller] && !params[:controller].include?("devise") && !params[:controller].include?("registrations")
      current_user.user_audits.create(:controller => params[:controller], :action => params[:action], :request => params)
    end
  end
  
  def logged_in?
    user_signed_in?
  end
  
  def home_path
    if current_user
      if current_user.role == "admin"
        admin_path
      elsif current_user.role == "business"
        dealdashboard_path
      elsif current_user.role == "user"
        mydeals_path
      end
    else
      root_path
    end
  end

  def after_inactive_sign_up_path_for(resource)
    session[:user_return_to] || root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    logger.info "CanCan access issue @ " + request.fullpath
    
    # Don't show error if this redirect is due to sign in/out
    notice = flash[:notice]
    if notice && notice.include?("Signed")
      flash[:notice] = notice
    # Only show error message if they are accessing a path other than root
    elsif request.fullpath != "/"
      flash[:alert] = "You are not signed in or are not permitted to do that."
    end
    logger.info "Redirecting to " + home_path
    redirect_to home_path
  end
end
