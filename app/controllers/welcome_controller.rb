class WelcomeController < ApplicationController

  def index
    session[:liked] = 0
    @offers = Offer.all(:limit => 4)
  end

  def mydeals
    session[:liked] = 0
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
    offer= Offer.find params[:offer_id]
    render :update do |page|
      page << "Effect.Shrink('offer_#{offer.id}');"
      if params[:liked]=='true'

        page.insert_html :bottom, 'my_list', list_offer(offer)

        session[:liked]+=1
        page << "alert('Time to sign up son!')" if session[:liked] > 2
      end
    end
  end

end
