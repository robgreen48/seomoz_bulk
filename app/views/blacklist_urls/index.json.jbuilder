json.array!(@blacklist_urls) do |blacklist_url|
  json.extract! blacklist_url, :domain
  json.url blacklist_url_url(blacklist_url, format: :json)
end