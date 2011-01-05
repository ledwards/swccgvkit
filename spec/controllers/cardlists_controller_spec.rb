require 'spec_helper'

describe CardlistsController do
  fixtures :users, :roles, :cards, :cardlists, :cardlist_items
  
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
        @user.cardlists << @cardlist
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
  
  describe "update_quantity" do
    before do
      @user = users(:user)
      sign_in @user
      
      @cardlist_item = cardlist_items(:cardlist_item)
      @user.cardlists << @cardlist_item.cardlist
      @valid_params = { :cardlist_item_id => @cardlist_item.id, :quantity => "10" }
    end
    
    context "for valid params" do
      it "is a success" do
        post :update_quantity, :format => :js, :cardlist_item_id => @cardlist_item.id, :quantity => "2"
        response.should be_success
      end
      
      it "updates the quantity of the cardlist item" do
        expect { post(:update_quantity, :format => :js, :cardlist_item_id => @cardlist_item.id, :quantity => "2"); @cardlist_item.reload }.should change(@cardlist_item, :quantity).by(1)
      end
    end
    
    context "for invalid params" do
      it "does not update the quantity of the cardlist item" do
        expect { post(:update_quantity, :format => :js, :cardlist_item_id => @cardlist_item.id, :quantity => "foo"); @cardlist_item.reload }.should_not change(@cardlist_item, :quantity)
      end
    end
  end
  
end
