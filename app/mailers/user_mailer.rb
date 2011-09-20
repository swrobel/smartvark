class UserMailer < ActionMailer::Base
  default :from => "Smartvark <noreply@smartvark.com>"

  def daily_deals(user, exclusive=nil)
    @user = user
    @exclusive = exclusive

    food_cats = Category.find("feed-me").subtree.map(&:id)
    @offer_food = Offer.active.where({:category_id => food_cats} & (:source ^ nil) & (:image_url_small ^ nil)).order("random()").limit(1).first
    
    other_cats = Category.where(:id - food_cats).map(&:id)
    @offer_other = Offer.active.where({:category_id => other_cats} & (:source ^ nil) & (:image_url_small ^ nil)).order("random()").limit(1).first
    
    subject = "Today's Deal Battle: " + @offer_food.businesses.first.name + " vs " + @offer_other.businesses.first.name
    mail(:to => user.email, :from => "Smartvark Deals <deals@smartvark.com>", :subject => subject)  
  end
end
