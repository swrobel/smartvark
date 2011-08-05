class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?, :geo_location, :home_path

  after_filter :log_user
  
  def makebiz
    if current_user
      current_user.role = 'business'
      current_user.save
      flash[:notice] = "#{current_user.email} is now a business user"
    else
      flash[:alert] = "You can only do this when logged in"
    end
    redirect_to new_business_path
  end

protected
  
  def geo_location
    # workaround because remote_location returns a bunk value when running on localhost
    if Rails.env.development?
      ip_location = LA
    else
      ip_location = request.location
      logger.info ip_location
      logger.info ip_location.latitude.to_s+","+ip_location.longitude.to_s
      ip_location = Geocode.find_or_create_by_query(ip_location.latitude.to_s+","+ip_location.longitude.to_s)
    end
    logger.info ip_location
    loc = ip_location || LA
    
    loc = LA
    if current_user
      loc = current_user.geocode if current_user.geocode #&& current_user.geocode.precision >= ip_location.precision
    elsif cookies.signed[:geo_location]
      loc = Marshal.load(cookies.signed[:geo_location])
    end
    return loc
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
      if current_user.role == "pending"
        new_user_invitation_path
      elsif current_user.role == "user"
        mydeals_path
      elsif current_user.role == "admin"
        mydeals_path
      elsif current_user.role == "business"
        dealdashboard_path
      end
    else
      root_path
    end
  end
  
  # Override Devise method to redirect Biz users to Deal Dashboard
  # Everyone else goes to where they were before
  def redirect_location(scope, resource)
    if resource.is_a?(User) && resource.role == "business"
      if resource.contract_accepted_at.blank?
        agreement_path
      elsif resource.name.blank? || resource.businesses.blank?
        new_business_path
      else
        dealdashboard_path
      end
    else
      stored_location_for(scope) || after_sign_in_path_for(resource)
    end
  end

  rescue_from CanCan::AccessDenied do
    logger.info "CanCan access issue @ #{request.fullpath}"
    
    # Don't show error if this redirect is due to sign in/out
    notice = flash[:notice]
    if notice
      flash[:notice] = notice
    # Only show error message if they are accessing a path other than root
    elsif request.fullpath != "/" && request.fullpath != "/deals"
      flash[:alert] = "You are not signed in or are not permitted to do that."
    end
    logger.info "Redirecting to #{home_path}"
    redirect_to home_path
  end
end
