require 'spec_helper'

describe CardsController do
  fixtures :users, :roles, :roles_users
  
  describe "GET 'index'" do
    it "should be successful for any logged in user" do
      sign_in users(:user)
      get 'index'
      response.should be_success
    end
    
    it "should assign a page of cards" do
      sign_in users(:user)
      get 'index', :page => 1
      assigns(:cards).map(&:title).should =~ Card.paginate(:page => 1, :order => 'title DESC').map(&:title)
    end
  end

  describe "GET 'new'" do
    it "should be successful for any logged in admin" do
      @admin = users(:admin)
      @admin.has_role?(:admin).should be_true
      sign_in @admin
      get 'new'
      response.should be_success
    end
  end

end
