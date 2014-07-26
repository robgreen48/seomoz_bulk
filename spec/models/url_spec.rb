require 'spec_helper'

describe Url do
  
  describe ".scrape_matches" do

		it "returns the page title" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news/")
			VCR.use_cassette('www.bbc.co.uk/news/') do
				url.scrape_matches
			end
			expect url.title.should eql "BBC News - Home"
		end

		it "returns the meta description" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news/")
			VCR.use_cassette('www.bbc.co.uk/news/') do
				url.scrape_matches
			end
			expect url.description.should eql "Visit BBC News for up-to-the-minute news, breaking news, video, audio and feature stories. BBC News provides trusted World and UK news as well as local and regional perspectives. Also entertainment, business, science, technology and health news."
		end

		it "returns the canonical tag" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news/")
			VCR.use_cassette('www.bbc.co.uk/news/') do
				url.scrape_matches
			end
			expect url.canonical_url.should eql "http://www.bbc.co.uk/news/"
		end

		it "returns the first matching twitter URL" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "www.propellernet.co.uk")
			VCR.use_cassette('www.propellernet.co.uk') do
				url.scrape_matches
			end
			expect url.twitter.should eql "https://twitter.com/Propellernet"
		end

		it "follows redirections and scrapes final page" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "news.bbc.co.uk")
			VCR.use_cassette('news.bbc.co.uk') do
				url.scrape_matches
			end
			expect url.title.should eql "BBC News - Home"
		end

		it "should set a scrape status of scrape done on successful completion" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news/")
			VCR.use_cassette('www.bbc.co.uk/news/') do
				url.scrape_matches
			end
			expect url.status.should eql "scrape done"
		end

		it "returns the HTTP code 301 when a permanent redirect exists" do
			pending
		end

		it "returns the HTTP code 200 when no redirection exists" do
			report = Report.create(:name => "Test Report")
			url = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news/")
			VCR.use_cassette('www.bbc.co.uk/news/') do
				url.scrape_matches
			end
			expect url.http_status.should eql "200 OK"
		end

	end

	describe ".normalise" do

		it "remove http:// from the URL" do
			url = Url.normalise("http://www.test.com")
			expect url.should eql "www.test.com"
		end

		it "remove https:// from the URL" do
			url = Url.normalise("https://www.test.com")
			expect url.should eql "www.test.com"
		end

		it "remove white space either side of the URL" do
			url = Url.normalise(" http://www.test.com ")
			expect url.should eql "www.test.com"
		end

		it "should not alter an already normalised URL" do
			url = Url.normalise("www.test.com ")
			expect url.should eql "www.test.com"
		end

	end

	describe ".get_host_and_suffix" do

		it "get host names from the uri" do
			url = Url.create(:uri => "http://www.bbc.co.uk/news")
			expect url.domain.should eql "www.bbc.co.uk"
		end

		it "get public facing suffix from the uri" do
			url = Url.create(:uri => "http://www.bbc.co.uk/news")
			expect url.public_suffix.should eql "co.uk"
		end
	end

	describe ".get_linkscape_data" do

		client = Linkscape::Client.new(:accessID => "member-20de2fa4a6", :secret => "0d8ac3e7fe8ca9173e0e6fdb321d3102")
		response = client.urlMetrics("http://www.bbc.co.uk/news", :cols => :all)

		it "returns DA of 100 for BBC" do
			expect response.data[:domain_authority].should eql 100
		end

		it "returns a value for PA for BBC" do
			expect response.data[:page_authority].should_not eql nil
		end
	end

	describe ".check_lists" do

		report = Report.create(:name => "Test Report")
		white = WhitelistUrl.create(:domain => "www.goodsite.com")
		black = BlacklistUrl.create(:domain => "www.badsite.com")

		it "sets list to white for a whitelisted domain" do
			url = Url.create(:report_id => report.id, :uri => "www.goodsite.com/stuff")
			expect url.list.should eql "White"
		end

		it "sets list to black for a blacklisted domain" do
			url = Url.create(:report_id => report.id, :uri => "www.badsite.com/some/other/stuff")
			expect url.list.should eql "Black"
		end

		it "sets list to not listed for a not listed domain" do
			url = Url.create(:report_id => report.id, :uri => "www.someothersite.com")
			expect url.list.should eql "Not Listed"
		end

		it "strips a whitelist url to just the host" do
			new_white = WhitelistUrl.create(:domain => "http://www.goodsite.com/nicepage")
			expect new_white.domain.should eql "www.goodsite.com"
		end

		it "strips a blacklist url to just the host" do
			new_black = BlacklistUrl.create(:domain => "http://www.badsite.com/badpage")
			expect new_black.domain.should eql "www.badsite.com"
		end
	end

end