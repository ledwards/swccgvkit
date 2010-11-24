require 'spec_helper'
include Devise::TestHelpers

describe CardsController do
  fixtures :users, :roles, :roles_users
  
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
      @admin.has_role?(:admin).should be_true
      sign_in @admin
      get 'new'
      puts response.body
      response.should be_success
    end
  end

end
