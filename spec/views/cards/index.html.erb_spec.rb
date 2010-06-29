require 'spec_helper'

describe "cards/index.html.erb" do
  it "renders an index of cards" do
    render
    rendered.should contain "Cards"
  end
end
