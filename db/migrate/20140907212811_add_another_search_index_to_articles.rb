class AddAnotherSearchIndexToArticles < ActiveRecord::Migration
  def up
      add_column :articles, :tsv_keywords, :tsvector

	  # Adds an index for this new column
	  execute <<-SQL
	    CREATE INDEX index_articles_tsv_keywords ON articles USING gin(tsv_keywords);
	  SQL

	  # Updates existing rows so this new column gets calculated
	  execute <<-SQL
	    UPDATE articles SET tsv_keywords = (to_tsvector('english', coalesce(keywords, '')));
	  SQL

	  # Sets up a trigger to update this new column on inserts and updates
	  execute <<-SQL
	    CREATE TRIGGER tsvector_keywords_update BEFORE INSERT OR UPDATE
	    ON articles FOR EACH ROW EXECUTE PROCEDURE
	    tsvector_update_trigger(tsv_keywords, 'pg_catalog.english', keywords);
	  SQL
  end

  def down
  	remove_column :articles, :tsv_keywords
    execute "drop index articles_tsv_keywords"
  end
end
