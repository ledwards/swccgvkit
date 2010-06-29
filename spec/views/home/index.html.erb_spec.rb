require 'spec_helper'

describe "home/index.html.erb" do
  it "renders a welcome screen" do
    render
    rendered.should contain "Welcome"
  end
end
