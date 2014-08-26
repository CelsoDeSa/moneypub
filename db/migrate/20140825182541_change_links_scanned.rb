class ChangeLinksScanned < ActiveRecord::Migration
  def up
    change_table :links do |t|
      t.change :scanned, :boolean, default: false
    end
  end
 
  def down
    change_table :links do |t|
      t.change :scanned, :boolean, default: true
    end
  end
end
