class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?, :geo_location, :home_path

  after_filter :log_user

protected
  
  def set_location
    cookies[:geo_location] = { :value => params[:location], :expires => 1.day.from_now }
  end

  def geo_location
    #if current_user
    #  if current_user.geocode
    #    if current_user.geocode.precision >= remote_location.precision
    #      current_user.geocode
    #    else
    #      remote_location
    #    end
    #  end
    #else
    #  cookies[:geo_location] || remote_location || 'Los Angeles, CA'
    #end
    "Los Angeles, CA"
  end

  def close_business_ids
    #business_ids = Business.select("businesses.id").origin(geo_location, :within => 25).order(:distance).limit(10)
    business_ids = Business.select("businesses.id").limit(10)
  end

private

  def log_user
    if current_user && params[:controller] && !params[:controller].include?("devise") && !params[:controller].include?("registrations")
      if is_mobile_browser?
        current_user.user_audits.create(:browser => device_model.to_s, :os => device_brand.to_s, :controller => params[:controller], :action => params[:action], :request => params)
      else
        current_user.user_audits.create(:controller => params[:controller], :action => params[:action], :request => params)
      end
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
