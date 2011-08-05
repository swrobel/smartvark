class UserMailer < ActionMailer::Base
  default :from => "Smartvark <noreply@smartvark.com>"

  def daily_deals(user)   
    mail(:to => user.email, :from => "Smartvark Local Deals <deals@smartvark.com>", :subject => "Your personalized daily deal picks from Smartvark")  
  end
end
