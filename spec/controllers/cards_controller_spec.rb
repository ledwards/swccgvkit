require 'spec_helper'
include Devise::TestHelpers

describe CardsController do
  fixtures :users
  
  describe "GET 'index'" do
    it "should be successful for any logged in user" do
      @user = users(:user)
      sign_in @user
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful for any logged in admin" do
      @admin = users(:admin)
      @admin.roles << Role.admin #shoudl be able to remove this
      sign_in @admin
      get 'new'
      response.should be_success
    end
  end

end
