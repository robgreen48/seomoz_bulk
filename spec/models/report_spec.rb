require 'spec_helper'

describe Report do

  describe ".completed" do

		it "returns true if all URLs have been scraped" do
			report = Report.create(:name => "Test Report")
			url_1 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/", :status => "scrape done")
			url_2 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news", :status => "scrape done")
			url_3 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/sport/", :status => "scrape done")
			expect report.completed.should eql true
		end

		it "returns false if not all URLs have been scraped" do
			report = Report.create(:name => "Test Report")
			url_1 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/", :status => "scrape done")
			url_2 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news", :status => "scrape done")
			url_3 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/sport/")
			expect report.completed.should eql false
		end

	end

	describe ".to_csv" do

		it "returns a CSV with some content" do
			report = Report.create(:name => "Test Report")
			url_1 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/", :status => "scrape done")
			url_2 = Url.create(:report_id => report.id, :uri => "www.bbc.co.uk/news", :status => "scrape done")

			VCR.use_cassette('www.bbc.co.uk') do
				url_1.scrape_matches
			end

			VCR.use_cassette('www.bbc.co.uk/news') do
				url_2.scrape_matches
			end

			expect report.to_csv.should_not eql nil

		end

	end

	describe ".percentage_complete" do
		it "returns the percentage of URLs in a report that have been scraped" do
			report = Report.create(:name => "Test Report")
			url_1 = Url.create(:report_id => report.id, :uri => "www.test.com", :status => "scrape done")
			url_2 = Url.create(:report_id => report.id, :uri => "www.test2.com", :status => "scrape done")
			url_3 = Url.create(:report_id => report.id, :uri => "www.test3.com", :status => "not done")
			url_4 = Url.create(:report_id => report.id, :uri => "www.test4.com", :status => "not done")

			expect report.percentage_complete_message.should eql "In Progress (50%)"

		end

		it "says not started if no urls have been created" do
			report = Report.create(:name => "Test Report")

			expect report.percentage_complete_message.should eql "Not Started"

		end
	end

end
