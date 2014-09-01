class Site < ActiveRecord::Base
	has_many :articles
	has_many :links
	has_one :scheduler
	has_one :history_queue
	has_one :score

	after_create :schedule_site_crawl, :update_feed, :add_score#, :calculate_score

	#def self.search(query)
	#	Article.search_by_title_and_keywords(query)
	#end

	def add_score
		Score.calculate_score(self.id)
	end

	def update_feed
		self.update(feed:  FeedSearcher.search(self.site_url).first) || ""
	end

	def schedule_site_crawl
		Scheduler.create(schedule: self.id, site_id: self.id)
	end
end
