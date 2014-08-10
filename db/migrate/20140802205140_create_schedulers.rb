class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.integer :schedule
      t.belongs_to :site, index: true

      t.timestamps
    end
  end
end
