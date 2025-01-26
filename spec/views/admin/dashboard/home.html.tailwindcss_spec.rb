require 'rails_helper'

RSpec.describe "admin/dashboard/home.html.erb", type: :view do
  it "renders the dashboard home page" do
    render
    expect(rendered).to match(/Dashboard#home/)
  end
end
