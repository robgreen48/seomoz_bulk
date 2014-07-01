require 'spec_helper'

describe "reports/show" do
  before(:each) do
    @report = assign(:report, stub_model(Report,
      :name => "Name",
      :site_url => "Site Url",
      :creator_email => "Creator Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Site Url/)
    rendered.should match(/Creator Email/)
  end
end
