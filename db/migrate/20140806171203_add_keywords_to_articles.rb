class AddKeywordsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :keywords, :string, array: true
  end
end
