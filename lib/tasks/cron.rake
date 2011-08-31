desc "Run scheduled tasks"
task :cron => :environment do
  import = Import.create
  import.from_sqoot
  import.save
  Offer.archive_expired
  emails = ["swrobel@gmail.com"]
  emails.each do |email|
    UserMailer.daily_deals(email).deliver
  end
end