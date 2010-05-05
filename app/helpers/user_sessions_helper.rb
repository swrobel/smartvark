module UserSessionsHelper
  def get_user_session
    @user_session ||= UserSession.new
  end
end
