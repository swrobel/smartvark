# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Geokit::Geocoders
  RADIUS=50
  
  include ActiveDevice
  skip_before_filter :set_mobile_format # instead of requiring mobile pages to be .mobile.erb use .html.erb
  before_filter :mobile_redirect # check for mobile browser and redirect to mobile page

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?, :location

  after_filter :log_user

  protected
  
#  def set_location
#    cookies[:geo_location] = { :value => params[:location], :expires => 1.day.from_now }
#  end

#  def location
#    (cookies[:geo_location] ||= 'Los Angeles, CA').to_str
#  end

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
    if is_mobile_browser? && !(request.request_uri+"/").include?("/m/")
      redirect_to "/m" + request.request_uri
    end
  end

  def log_user
    current_user && current_user.user_audits.create(:request => params)
  end
  
  def logged_in?
    current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    logger.info "CanCan access issue"
    # Don't show error if this redirect is due to sign in/out
    notice = flash[:notice]
    if notice && notice.include?("Signed")
      logger.info "Flash notice: " + notice.to_s
      flash[:notice] = notice
    else
      flash[:alert] = "You are not signed in or are not permitted to do that."
    end
    if current_user
      if current_user.role == "admin"
        redirect_to admin_path
      elsif current_user.role == "business"
        redirect_to dealdashboard_path
      elsif current_user.role == "user"
        redirect_to mydeals_path
      end
    else
      redirect_to root_path
    end
  end
end
