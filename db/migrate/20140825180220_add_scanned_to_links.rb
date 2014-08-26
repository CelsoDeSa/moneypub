class AddScannedToLinks < ActiveRecord::Migration
  def change
    add_column :links, :scanned, :boolean, default: true
  end
end
