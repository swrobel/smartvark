class UserMailer < ActionMailer::Base
  default :from => "Smartvark <noreply@smartvark.com>"

  def daily_deals(user)
    food_cats = Category.find("feed-me").subtree.map(&:id)
    @offer_1 = Offer.active.where(:category_id => food_cats).order("random()").limit(1).first
    
    other_cats = Category.where(:id - food_cats).map(&:id)
    @offer_2 = Offer.active.where(:category_id => other_cats).order("random()").limit(1).first
    
    mail(:to => user.email, :from => "Smartvark Local Deals <deals@smartvark.com>", :subject => "Your personalized daily deal picks from Smartvark")  
  end
end
