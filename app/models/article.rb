class Article < ActiveRecord::Base
  belongs_to :site

  validates :article_url, presence: true, uniqueness: true
  validates :title, :keywords, presence: true

  include PgSearch
  	multisearchable against: [:title, :keywords]

  def self.create_if_valid(title, page_url, density, id)
  	Article.create(
		title: title,
		article_url: page_url,
		keywords: density,
		site_id: id
	).valid?
  end

  #def self.deduplicate #procurava por duplicatas e as destruir
    # find all models and group them on keys which should be common
  #  grouped = all.group_by{|model| [model.title, model.article_url, model.site_id] }
  #  grouped.values.each do |duplicates|
      # the first one we want to keep right?
  #    first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
  #   duplicates.each{|double| double.destroy} # duplicates can now be destroyed
  #  end
  #end

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
