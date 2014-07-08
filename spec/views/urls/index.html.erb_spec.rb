require 'spec_helper'

describe "urls/index" do
  before(:each) do
    assign(:urls, [
      stub_model(Url,
        :report_id => 1,
        :uri => "Uri",
        :domain_authority => 2,
        :page_authority => 3,
        :ext_links => 4,
        :links => 5,
        :canonical_url => "Canonical Url",
        :title => "Title"
      ),
      stub_model(Url,
        :report_id => 1,
        :uri => "Uri",
        :domain_authority => 2,
        :page_authority => 3,
        :ext_links => 4,
        :links => 5,
        :canonical_url => "Canonical Url",
        :title => "Title"
      )
    ])
  end

  it "renders a list of urls" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Uri".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Canonical Url".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
