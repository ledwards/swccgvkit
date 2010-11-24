require 'spec_helper'
require "cancan/matchers"

describe User do
  fixtures :users, :roles, :roles_users
  
  before do
    @user = users(:user)
    @admin = users(:admin)
  end
  
  it "has a user factory" do
    Factory(:user).should be_valid
  end
  
  it "has an admin fixture" do
    @admin.has_role?(:admin).should be_true
  end
  
  it "is valid with valid attributes" do
    @user.should be_valid
  end
  
  it "is not valid with no email address" do
    @user.email = ""
    @user.should_not be_valid
  end
  
  it "is not valid with a poorly formed email address" do
    @user.email = "not.an.email.address"
    @user.should_not be_valid
  end
  
  it "is not valid with no password" do
    @user.password = ""
    @user.should_not be_valid
  end
  
  it "is not valid with mismatched passwords" do
    @user.password = "noooooooooooooooo"
    @user.password_confirmation = "iwantthemalive"
    @user.should_not be_valid
  end
end
