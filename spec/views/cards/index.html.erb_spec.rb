require 'spec_helper'

describe "cards/index.html.erb" do
  it "renders an index of cards" do
    # sign_in here
    render
    rendered.should contain "Cards"
  end
end
