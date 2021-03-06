class Ability
  include CanCan::Ability
 
  def initialize(user)
    if user
      if user.role == "admin"
        can :manage, :all
      elsif user.role == "user"
        can :read, :mydeals
        can :read, :myprofile
        can :read, :redeem
        # Below are here until invite system is removed, then Everyone at bottom
        can :read, :mypicks
      elsif user.role == "business"
        can :read, :mydeals
        can :read, :dealdashboard
        can :read, :agreement
        can :read, :purchase_credits
        can :create, Business
        can :update, Business do |business|
          business.try(:user) == user
        end
        can [:create, :print], Offer
        can [:edit, :update, :destroy], Offer do |offer|
          offer.try(:businesses).try(:first).try(:user) == user
        end
      end
    else # "Guest" users
      can :read, :index
      can :read, :deals
    end
    # Everyone can see these
    can :read, :search
    can :read, :viewdeal
    can :read, :viewbusiness
  end
end
