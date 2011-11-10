class CronJob
  def perform  
    puts "Cron: Import from Sqoot @ #{Time.now}"
    import = Import.create
    import.from_sqoot("Los Angeles", 5000)
    import.save
    
    puts "Cron: Archive expired offers @ #{Time.now}"
    Offer.archive_expired

    if Rails.env.production? && Time.now.hour == 9
      puts "Cron: Email users @ #{Time.now}"
      exclusive = Offer.find(85)
      users = User.where(:role => "user").where(:zipcode ^ nil).where(:latitude ^ nil)
      users.each do |user|
        begin
          mail = UserMailer.daily_deals(user, exclusive)
          mail.deliver if mail
        rescue => ex
          Airbrake.notify(ex, parameters: {email: user.email})
        end
      end
    end

    puts "Cron: Done @ #{Time.now}"
  end  
end