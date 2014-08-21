class CreateHistoryQueues < ActiveRecord::Migration
  def change
    create_table :history_queues do |t|
      t.string :history, array: true
      t.string :queue, array: true
      t.belongs_to :site, index: true, using: 'gist'

      t.timestamps
    end
  end
end
