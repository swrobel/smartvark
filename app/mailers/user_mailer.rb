class UserMailer < ActionMailer::Base
  default :from => "Smartvark <noreply@smartvark.com>"

  def daily_deals(user, exclusive=nil)
    @user = user
    @exclusive = exclusive

    opinions = user.opinions.map(&:offer_id)
    emailed_offers = user.emailed_offers.map(&:offer_id)

    loc = user.to_coordinates || LA.coordinates

    food_cats = Category.find("feed-me").subtree.map(&:id)
    @offer_food = Offer.active.joins(:businesses).where({:category_id => food_cats} & (:source ^ nil) & (:image_url_small ^ nil) & {:businesses => [:id + Business.ids_close_to(loc)]}).order("random()").limit(1)
    @offer_food = @offer_food.where(:id - opinions) unless opinions.empty?
    @offer_food = @offer_food.where(:id - emailed_offers) unless emailed_offers.empty?
    @offer_food = @offer_food.first
    
    other_cats = Category.where(:id - food_cats).map(&:id)
    @offer_other = Offer.active.joins(:businesses).where({:category_id => other_cats} & (:source ^ nil) & (:image_url_small ^ nil) & {:businesses => [:id + Business.ids_close_to(loc)]}).order("random()").limit(1)
    @offer_other = @offer_other.where(:id - opinions) unless opinions.empty?
    @offer_other = @offer_other.where(:id - emailed_offers) unless emailed_offers.empty?
    @offer_other = @offer_other.first

    email = user.emails.create
    email.emailed_offers.create(offer_id: @offer_food.id, user_id: user.id)
    email.emailed_offers.create(offer_id: @offer_other.id, user_id: user.id)
    
    subject = "Today's Deal Battle: " + @offer_food.businesses.first.name + " vs " + @offer_other.businesses.first.name
    mail(:to => user.email, :from => "Smartvark Deals <deals@smartvark.com>", :subject => subject)  
  end
end
