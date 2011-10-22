desc "Run scheduled tasks"
task :cron => :environment do
  Delayed::Job.enqueue(CronJob.new)
end