desc "Run scheduled tasks"
task :cron => :environment do
  import = Import.create
  import.from_yipit
  import.save
  Offer.archive_expired
  emails = ["swrobel@gmail.com","arhodes@rhombuscreative.com","jstandard@gmail.com","melissa.pena11@gmail.com","panisa.suwanarat.2011@anderson.ucla.edu"]
  emails.each do |email|
    UserMailer.daily_deals(email).deliver
  end
end