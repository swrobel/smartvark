desc "Run scheduled tasks"
task :cron => :environment do
  import = Import.create
  import.from_yipit
  import.save
  Offer.archive_expired
end