class Article < ActiveRecord::Base
  belongs_to :site

  validates :article_url, :keywords, presence: true, uniqueness: true
  validates :title, :site_id, presence: true

  include PgSearch
  	multisearchable against: [:title, :keywords]

  def self.score(id)
    articles = Article.where(site_id: id).size || 1
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
    elsif (1..10) === articles
      @score = 1
    end
  end

  def self.create_if_valid(title, page_url, density, id)
  	Article.create(
  		title: title,
  		article_url: page_url,
  		keywords: density,
  		site_id: id
	   ).valid?
  end

  def self.deduplicate #procurava por duplicatas e as destruir
     #find all models and group them on keys which should be common
    grouped = all.group_by{|model| [model.title, model.site_id] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
     duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end

  #def self.keywords_dedup
  #	articles = Article.all
  #	articles.each do |article|
	#  		k = article.keywords.to_s.scan(/(\w+)/)
	 # 		k.flatten!
	  #		words = WordsCounted::Counter.new(k.to_s)
	  #		words = words.word_density.flatten!
	  #		article.update(keywords: words)
  	#end
  #end

end
