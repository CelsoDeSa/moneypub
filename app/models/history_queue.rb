class HistoryQueue < ActiveRecord::Base
  #serialize :history, Array
  #serialize :queue, Array
  belongs_to :site

  validates :site_id, presence: true

  def self.update_by_id(history, queue, id)
  	@history = []
  	@queue = []
  	history_array =[]
  	queue_array = []

  	history_array = history
  	queue_array = queue

  	history_array.each {|site| @history << site.to_s}
  	queue_array.each {|site| @queue << site.to_s}

  	if @history or @queue
	  	hq = HistoryQueue.find_by(site_id: id)
	  		hq.history = @history
	  		hq.history_will_change!
	  		hq.save!

	  		hq.queue = @queue
	  		hq.queue_will_change!
	  		hq.save!
	end
  end
end
