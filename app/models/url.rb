class Url < ActiveRecord::Base
	belongs_to :report

	after_create :strip_domains
	after_create :get_all_data

	def get_all_data
		self.delay.get_linkscape_data
  		self.delay.scrape_matches
  	end

	def strip_domains
		whole_url = Domainatrix.parse(self.uri)
		self.update_attributes(:domain => whole_url.subdomain + "." + whole_url.domain + "." + whole_url.public_suffix, :public_suffix => whole_url.public_suffix)
  	end

	def get_linkscape_data
		client = Linkscape::Client.new(:accessID => "member-20de2fa4a6", :secret => "0d8ac3e7fe8ca9173e0e6fdb321d3102")
		response = client.urlMetrics(self.uri, :cols => :all)
		puts response.data
		self.update_attributes(:domain_authority => response.data[:domain_authority], :page_authority => response.data[:page_authority], :ext_links => response.data[:external_links], :links => response.data[:links])
	end

	def self.normalise(url)
	    url.downcase!
	    url.strip!
	    url.gsub!(/\/$/,'')
	    url.sub!(/https\:\/\//,'') 
	    url.sub!(/http\:\/\//, '')  
    	return url
  	end

  	def scrape_matches
  		require 'nokogiri'
		logger.info "Scraping " + self.uri

		begin

			open("http://"+self.uri) do |connection|
				@http_status = connection.status[0] + " " + connection.status[1]
				@raw_document_html = connection.read
			end

				document_html = @raw_document_html.force_encoding('iso8859-1').encode('utf-8')
				doc = Nokogiri::HTML(document_html)
				title = doc.xpath('//title/text()')
				description = doc.xpath("//meta[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='description']/@content")
				canonical = doc.xpath("//link[@rel='canonical']/@href")
				twitter = doc.xpath("//a[contains(@href,'twitter.com')]/@href[last()]")
				self.update_attributes(:title => title.to_s, :description => description.to_s, :canonical_url => canonical.to_s, :twitter => twitter.to_s, :http_status => @http_status, :status => "scrape done")

		rescue Exception => e
			logger.info "ERROR scraping " + "http://"+self.uri
			logger.info e
			self.update_attributes(:title => "ERROR", :description => "ERROR", :status => "error")
		end

	end


end