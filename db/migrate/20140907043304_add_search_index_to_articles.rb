class AddSearchIndexToArticles < ActiveRecord::Migration
  def up
      add_column :articles, :tsv_title, :tsvector

	  # Adds an index for this new column
	  execute <<-SQL
	    CREATE INDEX index_articles_tsv_title ON articles USING gin(tsv_title);
	  SQL

	  # Updates existing rows so this new column gets calculated
	  execute <<-SQL
	    UPDATE articles SET tsv_title = (to_tsvector('english', coalesce(title, '')));
	  SQL

	  # Sets up a trigger to update this new column on inserts and updates
	  execute <<-SQL
	    CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
	    ON articles FOR EACH ROW EXECUTE PROCEDURE
	    tsvector_update_trigger(tsv_title, 'pg_catalog.english', title);
	  SQL
  end

  def down
  	remove_column :articles, :tsv_title
    execute "drop index articles_tsv_title"
  end
end
