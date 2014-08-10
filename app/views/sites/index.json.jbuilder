json.array!(@sites) do |site|
  json.extract! site, :id, :name, :site_url, :feed, :description
  json.url site_url(site, format: :json)
end
