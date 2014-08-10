class Scheduler < ActiveRecord::Base
  belongs_to :site

  	def self.suicide(id)
  		if Site.find(id).articles.length > 0
	  		Scheduler.where(site_id: id).scoping do 
				Scheduler.first.destroy
			end
		end
  	end

	def self.extract(array)
		@words_bag = []
		@density = []

		if array
			array.each do |word| 
			   @words_bag << word.scan(/(\w+)/)
			   @words_bag.flatten!
			end		

			a_lot_of_words = WordsCounted::Counter.new(@words_bag.to_s)
			@density << a_lot_of_words.word_density.flatten!
		end
  	end

  	def self.spider(url)
  		Spidr.site(url, visit_urls_like: /(^([http:\/]|[https:\/])+[^\/]+\/+([^(\/|\?)]+\/){1,2}$)/) do |spider|
  		  	spider.every_page do |page|
				@body = []
				@title = ""

				@body.push page.doc.at('body').text rescue nil
				Scheduler.extract(@body)
				@title = page.title rescue nil
				@page_url = page.url.to_s

				Article.create_if_valid(@title, @page_url, @density, @id)
			end
		end

		#Scheduler.suicide(@id)
  	end

  	def self.crawl
  		site_scheduled = Scheduler.all

  		#if site_scheduled.length > 0
			site_scheduled.each do |site|
		  		@id = site.site_id
				@site = Site.find(@id)
				@uri = @site.site_url

			    url = URI.parse(@uri)
			    req = Net::HTTP.new(url.host, url.port)
			    res = req.request_head(url.path)

			    if res.code == "200"
			       Scheduler.spider(@uri)
			    else
			        next
			    end
		  	end
		#end
	end
end