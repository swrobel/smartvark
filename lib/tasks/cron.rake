desc "Archive expired offers"
task :cron => :environment do
  Offer.archive_expired
end
