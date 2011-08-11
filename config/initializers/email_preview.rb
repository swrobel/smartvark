EmailPreview.register 'Daily deals email' do
  u = User.find_by_email("swrobel@gmail.com")
  UserMailer.daily_deals(u)
end