class Url < ActiveRecord::Base
	belongs_to :report

	def get_linkscape_data
		client = Linkscape::Client.new(:accessID => "member-20de2fa4a6", :secret => "0d8ac3e7fe8ca9173e0e6fdb321d3102")
		response = client.urlMetrics(self.uri, :cols => :all)
		puts response.data
		self.update_attributes(:title => response.data[:title], :domain_authority => response.data[:domain_authority], :page_authority => response.data[:page_authority], :ext_links => response.data[:external_links], :canonical_url => response.data[:url], :links => response.data[:links], :status => "linkscape done")
	end

	def self.normalise(url)
	    url.downcase!
	    url.strip!
	    url.gsub!(/\/$/,'')
	    url.sub!(/https\:\/\//,'') 
	    url.sub!(/http\:\/\//, '')  
    	return url
  	end

  	def strip_domain
  		whole_url = Domainatrix.parse(self.uri)
  		self.update_attributes(:domain => whole_url.domain, :public_suffix => whole_url.public_suffix)
  	end
end