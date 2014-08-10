desc "This task is called by the Heroku scheduler add-on"

#rake crawl
task :crawl => :environment do
  puts "Crawling site..."
  Scheduler.crawl
  puts "done."
end