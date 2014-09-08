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

  	def self.extract_title_from_url(url)
  		string = url
  		@url_to_title = ""

  		match = string.match(/([^\/]+)\z/)
  		@url_to_title = match[0].gsub("-", " ")

  		@url_to_title  		
  	end

  	def self.crawl
  		@links = Link.not_visited.reverse_order

  		@links.each do |link|
	  		Spidr.site(link.url) do |spider|
	  		  	spider.every_html_page do |page|
					@body = []
					@title = ""

					@body.push page.doc.at('body').text rescue nil
					Scheduler.extract(@body)
					@title = page.title || page.doc.at('h1').text || Scheduler.extract_title_from_url(page.url.to_s)
					@page_url = page.url.to_s
					@id = link.site_id

					article = Article.create_if_valid(@title, @page_url, @density, @id)
					#if article.present?
					Link.update_visited_flag(link)
					#end
					spider.skip_page!
				end
			end
		end

		#Scheduler.suicide(@id)
  	end


  	def self.scan_site_links
  		@links = Link.not_scanned.reverse_order
  		@history = []
  		@queue = []
  		@list = []

  		@links.each do |link|
  			@id = link.site_id
  			@url = link.url
	  		history = Link.where(site_id: @id).scanned
	  		queue = Link.where(site_id: @id).not_scanned

	  		history.to_a.each { |link| @history << link.url }
  			queue.to_a.each { |link| @queue << link.url }

  			Spidr.site(@url, history: @history, queue: @queue, ignore_links: [/\?/, /feed(s|)/, /page(s|)/, /comment(s|)/]) do |spider|
			    spider.every_html_page do |page|
					@page_url = page.url.to_s
					Link.create_or_update_if_valid(@page_url, @id)
				end
					@list << spider.queue
					if @list.present?
						Link.enqueue(@list, @id)
					end
			end
		end
  	end

  	def self.add_site #antes scan_site
  		site_scheduled = Scheduler.all.reverse_order

  		#if site_scheduled.length > 0
  		#.each{|sch| puts sch.site.links.present?}
			site_scheduled.each do |schedule|
				#unless schedule.site.links.present? #testar
			  		@id = schedule.site_id
					@site = Site.find(@id)
					@uri = @site.site_url

				    url = URI.parse(@uri) rescue nil
				    req = Net::HTTP.new(url.host, url.port) rescue nil
				    res = req.request_head(url.path) rescue nil

				    if res == nil
				    	next
				    elsif res.code == "200" or res.code == "301"
				    	Link.create_or_update_if_valid(@uri, @id)
				    	#HistoryQueue.create(site_id: @id).valid?
				       	#Scheduler.add_url(@uri, @id)
				       	#criar um Link diretamente aqui e criar outra rake task para scan o site.
				    else
				        next
				    end
				#end
		  	end
		#end
	end

	def self.update_scores
		sites = Site.all.reverse_order

		sites.each {|site| Score.calculate_score(site.id) }		
	end
end
