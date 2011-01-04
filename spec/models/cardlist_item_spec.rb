require 'spec_helper'

describe CardlistItem do
  it "has a valid factory" do
    Factory.build(:cardlist_item).should be_valid
  end
end
