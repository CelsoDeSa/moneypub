class Site < ActiveRecord::Base
	has_many :articles
	has_many :links
	has_one :scheduler
	has_one :history_queue

	after_create :schedule_site_crawl, :update_feed#, :calculate_score

	#def self.search(query)
	#	Article.search_by_title_and_keywords(query)
	#end

	def self.alexa_calc(n)
		if n >= 90001
			@values[0] = 1
		elsif (80001..90000) === n
			@values[0] = 2
		elsif (70001..80000) === n
			@values[0] = 3
		elsif (60001..70000) === n
			@values[0] = 4
		elsif (50001..60000) === n
			@values[0] = 5
		elsif (40001..50000) === n
			@values[0] = 6
		elsif (30001..40000) === n
			@values[0] = 7
		elsif (20001..30000) === n
			@values[0] = 8
		elsif (10001..20000) === n
			@values[0] = 9
		elsif (1..10000) === n
			@values[0] = 10
		end
	end

	def self.calculate_score
		sites = Site.all

		sites.each do |site|
			rank = PageRankr.ranks(site.site_url, :alexa_global, :google)
			@values = []
			rank.each_value {|value| @values << value}
			#add another numbers here like books number, coments, etc
			alexa = @values[0]
			Site.alexa_calc(alexa)
			score = 0
			@values.each {|sum| score = score + (sum || 0)}
			score = (score / @values.length)*10
			site.update(score: score)
		end
	end

	def update_feed
		self.update(feed:  FeedSearcher.search(self.site_url).first) || ""
	end

	def schedule_site_crawl
		Scheduler.create(schedule: self.id, site_id: self.id)
	end
end
