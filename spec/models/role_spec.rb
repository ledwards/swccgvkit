require 'spec_helper'
require "cancan/matchers"

describe Role do
  fixtures :roles
  
  before do
    @role = Factory(:role)
    @admin = roles(:admin)
  end
  
  it "is invalid without a name" do
    @role.name = nil
    @role.should_not be_valid
  end
  
  it "has a named scope for admins" do
    Role.admin.should == [@admin]
  end
  
end
