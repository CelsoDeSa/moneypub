class Site < ActiveRecord::Base
	has_many :articles
	has_one :scheduler

	after_create :schedule_site_crawl, :update_feed

	#def self.search(query)
	#	Article.search_by_title_and_keywords(query)
	#end

	def update_feed
		self.update(feed:  FeedSearcher.search(self.site_url).first) || ""
	end

	def schedule_site_crawl
		Scheduler.create(schedule: self.id, site_id: self.id)
	end
end
