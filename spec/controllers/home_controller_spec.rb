require 'spec_helper'

describe HomeController do

  describe "GET 'home/index'" do
    it "should be successful for any logged in user" do
      @some_user = User.new(:email => "someuser@gmail.com", :password => "foobar", :password_confirmation => "foobar")
      @some_user.save
      sign_in @some_user
      get 'index'      
      response.should be_success
    end
  end

end
