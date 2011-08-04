desc "Run scheduled tasks"
task :cron => :environment do
  import = Import.new
  import.save
  import.from_yipit
  import.save
  Offer.archive_expired
end
