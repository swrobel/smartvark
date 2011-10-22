class CronJob
  def perform  
    puts "Cron: Import from Sqoot @ #{Time.now}"
    import = Import.create
    import.from_sqoot
    import.save
    
    puts "Cron: Archive expired offers @ #{Time.now}"
    Offer.archive_expired

    if Time.now.hour == 8  
      puts "Cron: Email users @ #{Time.now}"
      exclusive = Offer.find(85)
      #UserMailer.daily_deals(User.find_by_email("swrobel@gmail.com"), exclusive).deliver
      users = User.near("Los Angeles, CA",40).where(:role => "user")
      users.each do |user|
        begin
          UserMailer.daily_deals(user, exclusive).deliver
        rescue
          HoptoadNotifier.notify($!)
        end
      end
    end

    puts "Cron: Done @ #{Time.now}"
  end  
end