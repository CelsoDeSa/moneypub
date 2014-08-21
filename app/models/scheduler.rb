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
			@density << a_lot_of_words.word_density
			@density.first.delete_if {|word| word[1] < 0.1}
			@density.flatten!
		end
  	end

  	def self.crawl
  		@links = Link.not_visited

  		@links.each do |link|
	  		Spidr.site(link.url) do |spider|
	  		  	spider.every_html_page do |page|
					@body = []
					@title = ""

					@body.push page.doc.at('body').text rescue nil
					Scheduler.extract(@body)
					@title = page.title rescue nil
					@page_url = page.url.to_s
					@id = link.site_id

					article = Article.create_if_valid(@title, @page_url, @density, @id)

					if article
						Link.update_flag(link)
					end
					spider.skip_page!
				end
			end
		end

		#Scheduler.suicide(@id)
  	end


  	def self.add_url(url)

  		if Link.where(site_id: @id).present?
  			url = Link.where(site_id: @id).last.url
  			history = HistoryQueue.where(site_id: @id).first.history.to_set || []
  			queue = HistoryQueue.where(site_id: @id).first.queue || []
  			@hash = {}

  			Spidr.site(url, history: history, queue: queue, ignore_links: [/\?/, /feed/, /page/]) do |spider|
	  		  	spider.every_html_page do |page|
					@page_url = page.url.to_s

					if @page_url.match(/(^([http:\/]|[https:\/])+[^\/]+\/+([^\/?]+\/){1,2}$)/)
						Link.create_if_valid(@page_url, @id)
					end
				end
				@hash = spider.to_hash
				HistoryQueue.update(history: @hash[:history].to_a, queue: @hash[:queue], site_id: @id)
			end
  		else
  			@hash = {}
	  		Spidr.site(url, ignore_links: [/\?/, /feed/, /page/]) do |spider|
	  		  	spider.every_html_page do |page|
					@page_url = page.url.to_s

					if @page_url.match(/(^([http:\/]|[https:\/])+[^\/]+\/+([^\/?]+\/){1,2}$)/)
						Link.create_if_valid(@page_url, @id)
					end
				end
				@hash = spider.to_hash
				HistoryQueue.create(history: @hash[:history].to_a, queue: @hash[:queue], site_id: @id)
			end
		end
  	end

  	def self.scan_site
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
			       Scheduler.add_url(@uri)
			    else
			        next
			    end
		  	end
		#end
	end
end