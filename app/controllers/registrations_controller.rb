class RegistrationsController < Devise::RegistrationsController
  
  # PUT /resource
  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      flash[:alert] = "Could not update your account. See errors below."
      flash[:error] = "The following errors occurred:<ul>"
      resource.errors.full_messages.each do |msg|
        flash[:error] += "<li>" + msg + "</li>"
      end
      flash[:error] += "</ul>"
      clean_up_passwords(resource)
      redirect_to session[:user_return_to]
    end
  end
  
  def after_update_path_for(resource)
    session[:user_return_to] || root_path
#    if resource
#      if resource.role == "business"
#        new_busines_path
#      else
#        myprofile_path
#      end
#    else
#      root_path
#    end
  end
  
end
