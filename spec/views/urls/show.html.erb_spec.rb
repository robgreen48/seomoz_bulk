require 'spec_helper'

describe "urls/show" do
  before(:each) do
    @url = assign(:url, stub_model(Url,
      :report_id => 1,
      :uri => "Uri",
      :domain_authority => 2,
      :page_authority => 3,
      :ext_links => 4,
      :links => 5,
      :canonical_url => "Canonical Url",
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Uri/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/Canonical Url/)
    rendered.should match(/Title/)
  end
end
