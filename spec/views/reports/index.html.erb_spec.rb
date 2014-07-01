require 'spec_helper'

describe "reports/index" do
  before(:each) do
    assign(:reports, [
      stub_model(Report,
        :name => "Name",
        :site_url => "Site Url",
        :creator_email => "Creator Email"
      ),
      stub_model(Report,
        :name => "Name",
        :site_url => "Site Url",
        :creator_email => "Creator Email"
      )
    ])
  end

  it "renders a list of reports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Site Url".to_s, :count => 2
    assert_select "tr>td", :text => "Creator Email".to_s, :count => 2
  end
end
