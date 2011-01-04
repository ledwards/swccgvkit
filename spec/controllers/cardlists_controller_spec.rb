require 'spec_helper'

describe CardlistsController do
  fixtures :users, :roles, :cards, :cardlists
  
  describe "create" do
  end
  
  describe "add_card" do
    before do
      @user = users(:user)
      sign_in @user
      @card = Factory.create(:card)
    end
    
    it "should be successful for any logged in user" do
      post :add_card, :format => :js, :card_id => @card.id
      response.should be_success
    end
        
    context "current cardlist is nil" do
      before do
        @valid_params = { :card_id => @card.id }
      end
      
      it "creates a new cardlist" do
        expect { post :add_card, @valid_params }.should change(Cardlist, :count).by(1)
      end
      
      it "creates a new cardlist item" do
        expect { post :add_card, @valid_params }.should change(CardlistItem, :count).by(1)
      end
      
      it "scopes the cardlist to the current user" do
        post :add_card, @valid_params
        Cardlist.last.user.should == @user
      end
    end
    
    context "current cardlist exists" do
      before do
        @cardlist = cardlists(:cardlist)
        @valid_params_with_cardlist = { :cardlist_id => @cardlist.id, :card_id => @card.id }
      end
      
      it "does not create a new cardlist" do
        expect { post :add_card, @valid_params_with_cardlist }.should_not change(Cardlist, :count)
      end
      
      it "adds a card to the existing cardlist" do
        expect { post :add_card, @valid_params_with_cardlist; @cardlist.reload }.should change(@cardlist, :card_count).by(1)
      end
      
    end
  end
end
