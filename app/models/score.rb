class Score < ActiveRecord::Base
  belongs_to :site

	def self.article_score(id)
	    articles = Article.where(site_id: id).size
	    @score = 1

	    if articles > 1000
	      @score = 10
	    elsif (701..999) === articles
	      @score = 9
	    elsif (501..700) === articles
	      @score = 8
	    elsif (301..500) === articles
	      @score = 7
	    elsif (101..300) === articles
	      @score = 6
	    elsif (51..100) === articles
	      @score = 5
	    elsif (31..50) === articles
	      @score = 4
	    elsif (21..30) === articles
	      @score = 3
	    elsif (11..20) === articles
	      @score = 2
	    elsif (0..10) === articles
	      @score = 1
	    end
  	end

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

	def self.calculate_score(site_id) #pegar os dados do page rank e salvar nas variáveis e fazer update do Site.score
		site = Site.where(id: site_id).first
		
		@values = []
		ranks = []
		@scores = []

		ranks << PageRankr.ranks(site.site_url, :alexa_global) || {default: 90001}
		ranks << PageRankr.ranks(site.site_url, :google) || {default: 1}
		ranks << PageRankr.ranks(site.site_url, :moz_rank) || {default: 1}			
			
		ranks.each {|rank| @values << rank.values.first}

		article_score = Score.article_score(site.id)
		@values << article_score

		#add before alexa calc another values: reviews, books number, etc

		@values.each {|value| @scores << (value||1)}

		alexa = @values[0]
		Score.alexa_calc(alexa)

		scores = 0
		@values.each {|sum| scores = scores + (sum || 1)}
		score = (scores / @values.length)*10
		site.update(confidence: score)

		@scores << 0 #reviews
		@scores << 0 #booksS
		Score.create_or_update(@scores, site.id)		
	end

	def self.create_or_update(scores, site_id)
		score = Score.where(site_id: site_id).first
    
	    if score.present?
	      score.update(
	      	alexa: scores[0],
	      	google: scores[1],
	      	moz: scores[2],
	      	articles: scores[3],
	      	reviews: scores[4],
	      	books: scores[5],
	      	)
	    else      
	      Score.create(
	        alexa: scores[0],
	      	google: scores[1],
	      	moz: scores[2],
	      	articles: scores[3],
	      	reviews: scores[4],
	      	books: scores[5],
	      	site_id: site_id
	      )
	    end  
	end
end
