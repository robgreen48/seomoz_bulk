json.array!(@whitelist_urls) do |whitelist_url|
  json.extract! whitelist_url, :domain
  json.url whitelist_url_url(whitelist_url, format: :json)
end