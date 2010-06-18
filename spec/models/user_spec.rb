require 'spec_helper'

describe User do
  it "is valid with valid attributes" do
    user = User.new(:email => "darthvader@empire.com", :password => "iwantthemalive", :password_confirmation => "iwantthemalive")
    user.should be_valid
  end
  
  it "is not valid with no email address" do
    user = User.new(:email => nil, :password => "iwantthemalive", :password_confirmation => "iwantthemalive")
    user.should_not be_valid
  end
  
  it "is not valid with a poorly formed email address" do
    user = User.new(:email => "fake.whatisemail@wtf", :password => "iwantthemalive", :password_confirmation => "iwantthemalive")
    user.should_not be_valid
  end
  
  it "is not valid with no password" do
    user = User.new(:email => "darthvader@empire.com", :password => nil, :password_confirmation => "iwantthemalive")
    user.should_not be_valid
  end
  
  it "is not valid with mismatched passwords" do
      user = User.new(:email => "darthvader@empire.com", :password => "noooooooooooooooo", :password_confirmation => "iwantthemalive")
      user.should_not be_valid
    end  
end
