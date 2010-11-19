require 'spec_helper'
require "cancan/matchers"

describe User do
  fixtures :users
  
  before do
    @user = Factory.build(:user)
  end
  
  it "is valid with valid attributes" do
    p @user
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
