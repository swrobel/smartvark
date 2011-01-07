class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :logged_in?, :geo_location, :home_path

  after_filter :log_user
  
  def makebiz
    raise CanCan::AccessDenied unless can? :manage, :all
    user = User.find_by_email(params[:email])
    if user
      user.role = 'business'
      user.save
      flash[:notice] = "#{user.email} is now a business user"
    else
      flash[:alert] = "Couldn't find #{params[:email]}"
    end
    redirect_to session[:user_return_to] || root_path
  end

protected
  
  def geo_location
    # workaround because remote_location returns a bunk value when running on localhost
    if Rails.env.development?
      ip_location = LA
    else
      ip_location = remote_location
      ip_location = Geocode.create_from_location(ip_location) if ip_location
    end
    
    loc = ip_location || LA
    if current_user
      loc = current_user.geocode if current_user.geocode #&& current_user.geocode.precision >= ip_location.precision
    elsif cookies.signed[:geo_location]
      loc = Marshal.load(cookies.signed[:geo_location])
    end
    
    logger.info "Location info: #{loc} #{loc.to_location} #{loc.class}"
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
      if current_user.role == "admin"
        mydeals_path
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

  rescue_from CanCan::AccessDenied do
    logger.info "CanCan access issue @ #{request.fullpath}"
    
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
