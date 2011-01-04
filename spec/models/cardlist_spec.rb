require 'spec_helper'

describe Cardlist do
  fixtures :cards, :cardlists, :cardlist_items
  
  it "has a valid factory" do
    Factory.build(:cardlist).should be_valid
  end
  
  describe "#set_default_title" do
    it "sets the title to a default value if none is provided" do
      cardlist = Factory.create(:cardlist, :title => nil)
      cardlist.title.should_not be_nil
    end
  end
  
  describe "#card_count" do
    it "gives the total number of cards that have been added to the cardlist" do
      cardlist = cardlists(:cardlist)
      card = cards(:card)
      other_card = cards(:other_card)
      
      cardlist.add_card(card)
      2.times { cardlist.add_card(other_card) }
      
      cardlist.card_count.should == 3
    end
  end
  
  describe "#add_card" do
    before do
      @cardlist = cardlists(:cardlist)
    end
    
    context "adding a card that is not in the cardlist" do
      it "creates a new cardlist item" do
        card = cards(:card)
        expect { @cardlist.add_card(card) }.should change(CardlistItem, :count).by(1)
      end
    end
    
    context "adding a card that is already in the cardlist" do
      it "increments the quantity of the existing cardlist item" do
        card = cards(:card)
        cardlist_item = @cardlist.add_card(card)
        expect { @cardlist.add_card(card); cardlist_item.reload }.should change(cardlist_item, :quantity).by(1)
      end
      
      it "does not create a new cardlist item" do
        card = cards(:card)
        cardlist_item = @cardlist.add_card(card)
        expect { @cardlist.add_card(card); cardlist_item.reload }.should_not change(CardlistItem, :count)
      end
    end
  end
end
