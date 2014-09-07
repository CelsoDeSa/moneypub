class ChangeKeywordsColumnFromArticles < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.change :keywords, :text
    end
  end
 
  def down
    change_table :articles do |t|
      t.change :keywords, :string, array: true
    end
  end
end
