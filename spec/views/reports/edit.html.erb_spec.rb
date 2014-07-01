require 'spec_helper'

describe "reports/edit" do
  before(:each) do
    @report = assign(:report, stub_model(Report,
      :name => "MyString",
      :site_url => "MyString",
      :creator_email => "MyString"
    ))
  end

  it "renders the edit report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", report_path(@report), "post" do
      assert_select "input#report_name[name=?]", "report[name]"
      assert_select "input#report_site_url[name=?]", "report[site_url]"
      assert_select "input#report_creator_email[name=?]", "report[creator_email]"
    end
  end
end
