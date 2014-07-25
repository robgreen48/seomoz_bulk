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
			pending 
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

		it "returns some data from the SEOMoz API" do
			pending
		end

		it "returns DA" do
			pending
		end

		it "returns PA" do
			pending
		end
	end

end