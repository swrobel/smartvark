class Ability
  include CanCan::Ability
 
  def initialize(user)
    if user
      if user.role == "admin"
        can :manage, :all
      elsif user.role == "user"
        can :read, :mydeals
        can :read, :myprofile
      elsif user.role == "business"
        can :read, :mydeals
        can :read, :dealdashboard
        can :create, Business
        can :update, Business do |business|
          business.try(:user) == user
        end
        can :create, Offer
        can [:edit, :update, :destroy], Offer do |offer|
          offer.try(:businesses).try(:first).try(:user) == user
        end
      end
    else # "Guest" users
      can :read, :deals
    end
    
    # Everyone can see these
    can :read, :mypicks
    can :read, :viewdeal
    can :read, :viewbusiness
    can :read, :search
  end
end
