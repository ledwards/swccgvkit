require 'spec_helper'
include Devise::TestHelpers

describe CardsController do

  describe "GET 'index'" do
    it "should be successful for any logged in user" do
      @some_user = User.new(:email => "someuser@gmail.com", :password => "foobar", :password_confirmation => "foobar")
      @some_user.save
      sign_in @some_user
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful for any logged in admin" do
      @admin_user = User.new(:email => "someuser@gmail.com", :password => "foobar", :password_confirmation => "foobar")
      @admin_user.roles << Role.create(:name => "admin")
      @admin_user.save
      sign_in @admin_user
      get 'new'
      response.should be_success
    end
  end

end
