class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    logger.info env["omniauth.auth"]
    fbdata = env["omniauth.auth"]["extra"]["user_hash"]
    fbdata.delete("hometown")
    fbdata.delete("work")
    fbdata.delete("education")
    fbdata.delete("quotes")
    fbdata.delete("bio")
    logger.info fbdata
    session["devise.facebook_data"] = fbdata
    @user = User.find_for_facebook_oauth(fbdata, current_user)
    @user ||= User.new_with_session(params, session)
    @user.save unless @user.persisted?
    
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = fbdata
      flash[:alert] = "Facebook connect failed, please try again."
      redirect_to session[:user_return_to] || home_path
    end
  end
end