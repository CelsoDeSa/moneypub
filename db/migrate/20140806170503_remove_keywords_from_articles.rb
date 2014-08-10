class RemoveKeywordsFromArticles < ActiveRecord::Migration
  def up
  	remove_column :articles, :keywords, :text
  end

  def down
  	add_column :articles, :keywords, :text
  end
end
