class RegistrationsController < Devise::RegistrationsController
  
  # POST /resource/sign_up
  def create
    build_resource
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      flash[:alert] = "Could not complete signup. See errors below."
      flash[:error] = "<ul>"
      resource.errors.full_messages.each do |msg|
        flash[:error] += "<li>" + msg + "</li>"
      end
      flash[:error] += "</ul>"
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
      #redirect_to session[:user_return_to] || home_path
    end
  end
  
  # PUT /resource
  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      flash[:alert] = "Could not update your account. See errors below."
      flash[:error] = "<ul>"
      resource.errors.full_messages.each do |msg|
        flash[:error] += "<li>" + msg + "</li>"
      end
      flash[:error] += "</ul>"
      clean_up_passwords(resource)
      respond_with_navigational(resource){ render_with_scope :edit }
    end
    
    #redirect_to session[:user_return_to] || home_path
  end
  
  def after_update_path_for(resource)
    session[:user_return_to] || home_path
  end
  
end
