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
  
#  def set_location
#    cookies[:geo_location] = { :value => params[:location], :expires => 1.day.from_now }
#  end

#  def location
#    (cookies[:geo_location] ||= 'Los Angeles, CA').to_str
#  end

  def close_business_ids
    # business_ids = Business.all(:select => 'id', :origin => location, :within => RADIUS)  #TODO:  Sqlite not map supported
    @close_business_ids ||= Business.all(:select => 'id')
  end

  private
  
  def after_sign_in_path_for(resource_or_scope)
    prev_url = stored_location_for(resource_or_scope)
#    if prev_url && !(prev_url.equals? root_url)
#      return prev_url
#    else
#      return mydeals_path
#    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    prev_url = stored_location_for(resource_or_scope)
#    if prev_url && !(prev_url.equals? mydeals_url)
#      return prev_url
#    else
#      return root_path
#    end
  end

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
    flash[:alert] = "You are not signed in or are not permitted to do that."
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
