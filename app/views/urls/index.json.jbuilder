json.array!(@urls) do |url|
  json.extract! url, :report_id, :uri, :domain_authority, :page_authority, :ext_links, :links, :canonical_url, :title
  json.url url_url(url, format: :json)
end