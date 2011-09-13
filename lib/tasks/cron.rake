desc "Run scheduled tasks"
task :cron => :environment do
  import = Import.create
  import.from_sqoot
  import.save
  Offer.archive_expired
  users = User.near("Los Angeles, CA",40).where(:role => "user")
  users.each do |user|
    UserMailer.daily_deals(user).deliver
  end
end