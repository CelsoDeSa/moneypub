class DropHistoryQueuesTable < ActiveRecord::Migration
  def change
  	drop_table :history_queues
  end
end
