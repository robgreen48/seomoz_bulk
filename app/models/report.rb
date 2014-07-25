class Report < ActiveRecord::Base
	has_many :urls, dependent: :destroy

 	def create_urls(urls)
 		urls.each do |url|
        	Url.create(:report_id => self.id, :uri => Url.normalise(url), :status => 'not done')
		end
  end

  	def percentage_complete_message
    	if self.urls.first.nil?
    		message = "Not Started"
    	else
    		percentage = self.urls.where("status != 'not done'").count.fdiv(self.urls.count) * 100
    		message = "In Progress (" + percentage.round.to_s + "%)"
    	end
  	end

  	def completed
    	if self.urls.where("status = 'not done'").empty? && self.urls.first != nil
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
