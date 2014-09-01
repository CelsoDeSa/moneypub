class RenameScoreColumnFromSites < ActiveRecord::Migration
  def change
  	rename_column :sites, :score, :confidence
  end
end
