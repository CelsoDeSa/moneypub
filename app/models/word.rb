class Word

	def self.densities_scrap(query, search)
		words = query.split
		@words_densities = []

		words.each do |word|
			@words_densities << search.scan(/#{word}\s\w\.\w{1,2}/) rescue nil
		end

		@words_densities.flatten!
	end
end