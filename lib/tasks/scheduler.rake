desc "Run scheduled tasks"

task :sqoot_import => :environment do
  puts "Sqoot Import: start @ #{Time.now}"
  import = Import.create
  import.from_sqoot
  import.save
  puts "Sqoot Import: end @ #{Time.now}"
end

task :archive_expired_offers => :environment do
  puts "Archive Expired Offers: start @ #{Time.now}"
  Offer.archive_expired
  puts "Archive Expired Offers: end @ #{Time.now}"
end

task :daily_email => :environment do 
  puts "Daily Email: start @ #{Time.now}"
  exclusive = Offer.find(85)
  users = User.near("Los Angeles, CA",40).where(:role => "user")
  users.each do |user|
    begin
      UserMailer.daily_deals(user, exclusive).deliver
    rescue
      HoptoadNotifier.notify($!)
    end
  end

  puts "Daily Email: end @ #{Time.now}"
end