class WelcomeController < ApplicationController

  def mydeals
    @offers = Offer.all(:limit => 4)
  end

  def set_opinion
    if current_user
      current_user.set_opinion(params)
      current_user.save
    else
      session[:user] = User.new
      session[:user].set_opinion(params)
    end
    render :nothing => true
  end

end
