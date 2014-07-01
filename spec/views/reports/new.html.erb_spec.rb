require 'spec_helper'

describe "reports/new" do
  before(:each) do
    assign(:report, stub_model(Report,
      :name => "MyString",
      :site_url => "MyString",
      :creator_email => "MyString"
    ).as_new_record)
  end

  it "renders new report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", reports_path, "post" do
      assert_select "input#report_name[name=?]", "report[name]"
      assert_select "input#report_site_url[name=?]", "report[site_url]"
      assert_select "input#report_creator_email[name=?]", "report[creator_email]"
    end
  end
end
