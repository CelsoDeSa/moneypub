class AddScoreToSites < ActiveRecord::Migration
  def change
    add_column :sites, :score, :integer, default: 0
  end
end
