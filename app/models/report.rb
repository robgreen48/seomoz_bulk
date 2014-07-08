class Report < ActiveRecord::Base
	has_many :urls, dependent: :destroy

	def queue_jobs
  		self.urls.each do |url|
  			url.delay.get_linkscape_data
  		end
  	end

  	def percentage_complete
    	percentage = self.urls.where("status != 'not done'").count.fdiv(self.urls.count) * 100
  	end

  	def completed
    	if self.urls.where("status = 'not done'").empty?
      		return true
    	else
      	return false
    	end
  	end

  	def to_csv
    	heading_row = Array.new
    	heading_row =["URL", "DA", "PA", "External Links", "Links", "Canonical URL", "Title"]
    	CSV.generate do |csv|
      		csv << heading_row
      		self.urls.each do |url|
         		csv << [url.uri, url.domain_authority, url.page_authority, url.ext_links, url.links, url.canonical_url, url.title]
       		end
    	end
	end
end
