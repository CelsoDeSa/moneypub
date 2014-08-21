class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.boolean :visited, default: false
      t.belongs_to :site, index: true

      t.timestamps
    end
  end
end
