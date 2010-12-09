class RegistrationsController < Devise::RegistrationsController
  
  # POST /resource/sign_up
  def create
    build_resource

    if resource.save
      if resource.active?
        set_flash_message :notice, :signed_up
        sign_in_and_redirect(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s
        expire_session_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      flash[:alert] = "Could not complete signup. See errors below."
      flash[:error] = "<ul>"
      resource.errors.full_messages.each do |msg|
        flash[:error] += "<li>" + msg + "</li>"
      end
      flash[:error] += "</ul>"
      clean_up_passwords(resource)
      redirect_to session[:user_return_to] || root_path
    end
  end
  
  # PUT /resource
  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      flash[:alert] = "Could not update your account. See errors below."
      flash[:error] = "<ul>"
      resource.errors.full_messages.each do |msg|
        flash[:error] += "<li>" + msg + "</li>"
      end
      flash[:error] += "</ul>"
      clean_up_passwords(resource)
      redirect_to session[:user_return_to] || root_path
    end
  end
  
  def after_update_path_for(resource)
    session[:user_return_to] || root_path
  end
  
end
