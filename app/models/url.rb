class Url < ActiveRecord::Base
	belongs_to :report

	after_create :get_host_and_suffix
	after_create :check_lists
	
	after_create :get_all_data

	def categorise

		uri_and_title = self.uri + self.title


		if (uri_and_title.include? "wordpress") or (uri_and_title.include? "blog") or (uri_and_title.include? "Blog") or (uri_and_title.include? "Wordpress")
			self.update_attributes(:is_blog => true)
		else
			self.update_attributes(:is_blog => false)
		end

		if (uri_and_title.include? "directories") or (uri_and_title.include? "directory") or (uri_and_title.include? "dmoz") or (uri_and_title.include? "Directories") or (uri_and_title.include? "Directory") or (uri_and_title.include? "Dmoz")
			self.update_attributes(:is_directory => true)
		else
			self.update_attributes(:is_directory => false)
		end

		if self.domain.include? "article"
			self.update_attributes(:is_article => true)
		else
			self.update_attributes(:is_article => false)
		end

		if (uri_and_title.include? "forum") or (uri_and_title.include? "Forum") or(self.uri.include? "wthread") or (self.uri.include? "wtopic")
			self.update_attributes(:is_forum => true)
		else
			self.update_attributes(:is_forum => false)
		end

		if (uri_and_title.include? "link") or (uri_and_title.include? "Link")
			self.update_attributes(:is_link_page => true)
		else
			self.update_attributes(:is_link_page => false)
		end

		if self.domain.include? "wiki"
			self.update_attributes(:is_wiki => true)
		else
			self.update_attributes(:is_wiki => false)
		end

		if (self.domain.include? "gov.uk") or (self.domain.include? "ac.uk")
			self.update_attributes(:is_gov => true)
		else
			self.update_attributes(:is_gov => false)
		end

		if (self.domain.include? "pressrelease") or (self.domain.include? "press-release")
			self.update_attributes(:is_pr => true)
		else
			self.update_attributes(:is_pr => false)
		end

		if self.uri.include? "alexa"
			self.update_attributes(:is_scraper => true)
		else
			self.update_attributes(:is_scraper => false)
		end
	end

	def check_lists
		white = WhitelistUrl.find_by domain: self.domain
		black = BlacklistUrl.find_by domain: self.domain
		
		if white != nil
			self.update_attributes(:list => "White")
		end

		if black != nil
			self.update_attributes(:list => "Black")
		end

		if black == nil && white == nil
			self.update_attributes(:list => "Not Listed")
		end
	end

	def get_all_data
		self.delay.get_linkscape_data
  		self.delay.scrape_matches
  	end

	def get_host_and_suffix
		whole_url = Domainatrix.parse(self.uri) # parse url for public_suffix

		uri = URI.parse(self.uri)
  		uri = URI.parse("http://#{self.uri}") if uri.scheme.nil?
  		host = uri.host.downcase
  		host.start_with?('www.') ? host[4..-1] : host # get host name

		self.update_attributes(:domain => host, :public_suffix => whole_url.public_suffix)
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
    require 'open_uri_redirections'

		logger.info "Scraping " + self.uri

		begin

			open("http://"+self.uri, :allow_redirections => :all, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |connection|
				@http_status = connection.status[0] + " " + connection.status[1]
				@raw_document_html = connection.read
			end

				document_html = @raw_document_html.force_encoding('iso8859-1').encode('utf-8')
				doc = Nokogiri::HTML(document_html)
				title = doc.xpath('//title/text()')
				description = doc.xpath("//meta[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='description']/@content")
				canonical = doc.xpath("//link[@rel='canonical']/@href")
				twitter = doc.xpath("//a[contains(@href,'twitter.com')]/@href[last()]")
				self.update_attributes(:title => title.to_s.truncate(254), :description => description.to_s.truncate(254), :canonical_url => canonical.to_s.truncate(254), :twitter => twitter.to_s.truncate(254), :http_status => @http_status, :status => "scrape done")

		rescue Exception => e
			logger.info "ERROR scraping " + "http://"+self.uri
			logger.info e
			self.update_attributes(:title => "ERROR", :description => "ERROR", :status => "error")
		end

		self.categorise

	end

end