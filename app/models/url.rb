class Url < ActiveRecord::Base
	belongs_to :report

	def get_linkscape_data
		client = Linkscape::Client.new(:accessID => "member-20de2fa4a6", :secret => "0d8ac3e7fe8ca9173e0e6fdb321d3102")
		response = client.urlMetrics(self.uri, :cols => :all)
		puts response.data
		self.update_attributes(:title => response.data[:title], :domain_authority => response.data[:domain_authority], :page_authority => response.data[:page_authority], :ext_links => response.data[:external_links], :canonical_url => response.data[:url], :links => response.data[:links], :status => "done")
	end
end