desc "This task is called by the Heroku scheduler add-on"

#rake crawl
task :add_site => :environment do
  puts "Scanning site..."
  Scheduler.add_site
  puts "done."
end

task :scan_site_links => :environment do
  puts "Scanning site..."
  Scheduler.scan_site_links
  puts "done."
end

task :crawl => :environment do
  puts "Crawling site..."
  Scheduler.crawl
  puts "done."
end

task :calculate_score => :environment do
  puts "Calculating scores..."
  Site.calculate_score
  puts "done."
end