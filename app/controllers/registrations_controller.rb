class RegistrationsController < Devise::RegistrationsController
  
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
