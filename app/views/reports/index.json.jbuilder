json.array!(@reports) do |report|
  json.extract! report, :name, :site_url, :creator_email
  json.url report_url(report, format: :json)
end