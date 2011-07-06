require 'spec_helper'

describe CardsController do
  fixtures :users, :roles, :roles_users
  
  describe "GET 'index'" do
    before do
      sign_in users(:user)
    end

    it "should be successful for any logged in user" do
      get 'index'
      response.should be_success
    end
    
    it "should assign a page of cards" do
      Factory.create(:card, :expansion => "Virtual Set 1")
      get 'index', :page => 1
      assigns(:cards).map(&:title).should =~ Card.paginate(:page => 1, :order => 'title DESC').map(&:title)
    end

    it "shows only virtual cards" do
      match = Factory.create(:card, :expansion => "Virtual Set 1")
      Factory.create(:card, :expansion => "Death Star II")
      Card.stub_chain(:virtual, :search, :expansion, :side, :order, :paginate).and_return([match])
      get 'index'
      assigns(:cards).should == [match]
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

  describe "GET 'new'" do
    before do
      @admin = users(:admin)
      sign_in @admin
    end

    it "should be successful for any logged in admin" do
      get 'new'
      response.should be_success
    end

    it "renders the edit form" do
      get 'new'
      response.should render_template :edit
    end
  end

end
