class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :article_url
      t.text :keywords
      t.integer :site_id
      t.belongs_to :site, index: true

      t.timestamps
    end
  end
end
