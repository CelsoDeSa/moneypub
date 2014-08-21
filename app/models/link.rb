class Link < ActiveRecord::Base
  belongs_to :site

  validates :url, uniqueness: true
  validates :site_id, presence: true

  scope :not_visited, -> { where(visited: false) }

  def self.create_if_valid(page_url, id)
  	Link.create(
  		url: page_url,
  		site_id: id
	   ).valid?
  end

  def self.update_flag(link)
  	link.update(visited: true)
  end
end
