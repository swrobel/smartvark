class UserMailer < ActionMailer::Base
  default :from => "Smartvark <noreply@smartvark.com>"

  def daily_deals(user, exclusive=nil)
    @user = user
    @exclusive = exclusive

    opinions = user.opinions.values_of(:offer_id)
    emailed_offers = user.emailed_offers.values_of(:offer_id)

    loc = user.to_coordinates || LA.coordinates
    dist = 10

    food_cats = Category.find("feed-me").subtree.values_of(:id)
    other_cats = Category.where(:id - food_cats).values_of(:id)
    @offer_food = nil
    @offer_other = nil

    begin
      unless @offer_food
        @offer_food = Offer.active.joins(:businesses).where({:category_id => food_cats} & (:source ^ nil) & (:image_url_small ^ nil) & {:businesses => [:id + Business.ids_close_to(loc, dist)]}).order("random()").limit(1)
        @offer_food = @offer_food.where(:id - opinions) unless opinions.empty?
        @offer_food = @offer_food.where(:id - emailed_offers) unless emailed_offers.empty?
        @offer_food = @offer_food.first
      end
      
      unless @offer_other
        @offer_other = Offer.active.joins(:businesses).where({:category_id => other_cats} & (:source ^ nil) & (:image_url_small ^ nil) & {:businesses => [:id + Business.ids_close_to(loc, dist)]}).order("random()").limit(1)
        @offer_other = @offer_other.where(:id - opinions) unless opinions.empty?
        @offer_other = @offer_other.where(:id - emailed_offers) unless emailed_offers.empty?
        @offer_other = @offer_other.first
      end

      dist += 10
    end until (@offer_food && @offer_other) || dist > 100

    if @offer_food && @offer_other
      email = user.emails.create
      email.emailed_offers.create(offer_id: @offer_food.id, user_id: user.id)
      email.emailed_offers.create(offer_id: @offer_other.id, user_id: user.id)
      
      subject = "Today's Deal Battle: " + @offer_food.businesses.first.name + " vs " + @offer_other.businesses.first.name
      mail(:to => user.email, :from => "Smartvark Deals <deals@smartvark.com>", :subject => subject)
    else
      logger.info "User #{user.id} at #{user.email} had no deals within 100 miles"
    end
  end
end
