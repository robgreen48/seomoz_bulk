require 'spec_helper'

describe "urls/new" do
  before(:each) do
    assign(:url, stub_model(Url,
      :report_id => 1,
      :uri => "MyString",
      :domain_authority => 1,
      :page_authority => 1,
      :ext_links => 1,
      :links => 1,
      :canonical_url => "MyString",
      :title => "MyString"
    ).as_new_record)
  end

  it "renders new url form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", urls_path, "post" do
      assert_select "input#url_report_id[name=?]", "url[report_id]"
      assert_select "input#url_uri[name=?]", "url[uri]"
      assert_select "input#url_domain_authority[name=?]", "url[domain_authority]"
      assert_select "input#url_page_authority[name=?]", "url[page_authority]"
      assert_select "input#url_ext_links[name=?]", "url[ext_links]"
      assert_select "input#url_links[name=?]", "url[links]"
      assert_select "input#url_canonical_url[name=?]", "url[canonical_url]"
      assert_select "input#url_title[name=?]", "url[title]"
    end
  end
end
