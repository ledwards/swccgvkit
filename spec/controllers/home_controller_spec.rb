require 'spec_helper'

describe HomeController do

  describe "GET 'home/index'" do
    before do
      @some_user = User.new(:email => "someuser@gmail.com", :password => "foobar", :password_confirmation => "foobar")
      @some_user.save
      sign_in @some_user
    end

    it "is successful" do
      get 'index'
      response.should be_success
    end

    it "assigns the filtering ivars" do
      get 'index', :search => "search term", :direction => "dir", :sort => "title", :side => "Dark", :expansion => "Premiere"
      assigns[:search].should == "search term"
      assigns[:direction].should == "dir"
      assigns[:sort].should == "title"
      assigns[:side].should == "Dark"
      assigns[:expansion].should == "Premiere"
    end
  end
end
