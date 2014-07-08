class Report < ActiveRecord::Base
	has_many :urls, dependent: :destroy

	def strip_domains
		self.urls.each do |url|
  			whole_url = Domainatrix.parse(url.uri)
  			url.update_attributes(:domain => whole_url.subdomain + "." + whole_url.domain + "." + whole_url.public_suffix, :public_suffix => whole_url.public_suffix)
  		end
  	end

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
    	heading_row =["URL", "Domain", "TLD", "DA", "PA", "External Links", "Links", "Canonical URL", "Title"]
    	CSV.generate do |csv|
      		csv << heading_row
      		self.urls.each do |url|
         		csv << [url.uri, url.domain, url.public_suffix, url.domain_authority, url.page_authority, url.ext_links, url.links, url.canonical_url, url.title]
       		end
    	end
	end

end
