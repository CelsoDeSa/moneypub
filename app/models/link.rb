class Link < ActiveRecord::Base
  belongs_to :site

  validates :url, uniqueness: true, presence: true
  validates :site_id, presence: true

  scope :not_visited, -> { where(visited: false) }
  scope :visited, -> { where(visited: true) }

  scope :not_scanned, -> { where(scanned: false) }
  scope :scanned, -> { where(scanned: true) }

  def self.enqueue(list, id)
    @id = id
    @list = []
    list_array = list

    list_array.each {|site| @list << site.to_s}

    @list.flatten!
    @list.uniq!

    @list.each do |url|
        @url = url
        Link.create_or_update_if_valid(@url, @id)
    end    
  end

  def self.create_or_update_if_valid(page_url, id)
    @link = Link.where(url: page_url)
    
    if @link.present?
      Link.update_scanned_flag(@link.first)
    elsif page_url.match(/(^([http:\/]|[https:\/])+[^\/]+\/+([^\/?]+\/){1,2}$)/)      
      Link.create(
        url: page_url,
        site_id: id
      ).valid?
    end  	
  end

  def self.update_visited_flag(link)
  	link.update(visited: true)
  end

  def self.update_scanned_flag(link)
    link.update(scanned: true)
  end
end