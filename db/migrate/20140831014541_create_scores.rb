class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :alexa, null: false, default: 1
      t.integer :google, null: false, default: 1
      t.integer :moz, null: false, default: 1
      t.integer :articles, null: false, default: 1
      t.integer :reviews, null: false, default: 1
      t.integer :books, null: false, default: 1
      t.belongs_to :site, index: true

      t.timestamps
    end
  end
end
